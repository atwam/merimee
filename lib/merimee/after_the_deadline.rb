require 'crack'
require 'net/http'
require 'uri'

class AfterTheDeadline
  BASE_URIS = {
    'en' => 'http://service.afterthedeadline.com',
    'fr' => 'http://fr.service.afterthedeadline.com',
    'de' => 'http://de.service.afterthedeadline.com',
    'pt' => 'http://pt.service.afterthedeadline.com',
    'es' => 'http://es.service.afterthedeadline.com'
    }
  BASE_URI = 'http://service.afterthedeadline.com'

  class << self
    attr_accessor :key, :language
    # Invoke the checkDocument service with provided text.
    # 
    # Returns list of AfterTheDeadline::Error objects.
    def check(data)
      results = Crack::XML.parse(perform('/checkDocument', :data => data))['results']
      return [] if results.nil? # we have no errors in our data

      raise "Server returned an error: #{results['message']}" if results['message']
      errors = if results['error'].kind_of?(Array)
                 results['error'].map { |e| AfterTheDeadline::Error.new(e) }
               else
                 [AfterTheDeadline::Error.new(results['error'])]
               end

      return errors
    end
    alias :check_document :check

    # Invoke the stats service with provided text.
    # 
    # Returns AfterTheDeadline::Metrics object.
    def metrics(data)
      results = Crack::XML.parse(perform('/stats', :data => data))['scores']
      return if results.nil? # we have no stats about our data
      AfterTheDeadline::Metrics.new results['metric']
    end
    alias :stats :metrics

    def perform(action, params)
      uri = URI.parse(BASE_URIS[@language] + action)
      response = Net::HTTP.post_form uri, params.update(:key => @key)
      raise "Unexpected response code from AtD service: #{response.code} #{response.message}" unless response.is_a? Net::HTTPSuccess
      response.body
    end
  end

  private_class_method :perform
end

class AfterTheDeadline::Error
  attr_reader :string, :description, :precontext, :type, :suggestions, :url

  def initialize(hash)
    raise "#{self.class} must be initialized with a Hash" unless hash.kind_of?(Hash)
    [:string, :description, :precontext, :type, :url].each do |attribute|
      self.send("#{attribute}=", hash[attribute.to_s])
    end
    self.suggestions = hash['suggestions'].nil? ? [] : [*hash['suggestions']['option']]
  end

  def info(theme = nil)
    return unless self.url
    uri = URI.parse self.url
    uri.query = (uri.query || '') + "&theme=#{theme}"
    Net::HTTP.get(uri).strip
  end

  def to_s
    "#{self.string} (#{self.description})"
  end

  private
  attr_writer :string, :description, :precontext, :type, :suggestions, :url
end

class AfterTheDeadline::Metrics
  attr_reader :spell, :grammer, :stats, :style

  def initialize(array)
    unless array.kind_of?(Array) && array.all? {|i| i.kind_of?(Hash) }
      raise "#{self.class} must be initialized with an Array of Hashes"
    end

    self.spell, self.grammer, self.stats, self.style = {}, {}, {}, {}
    array.each do |metric|
      self.send(metric['type'])[metric['key']] = metric['value']
    end
  end

  private
  attr_writer :spell, :grammer, :stats, :style
end
