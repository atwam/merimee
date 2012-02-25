require 'digest/sha1'

module Merimee
  DEFAULT_IGNORE_TYPES = ['bias language', 'cliches', 'complex expression', 'diacritical marks', 'double negatives', 'hidden verbs', 'jargon language', 'passive voice', 'phrases to avoid', 'redundant expression']
  DEFAULT_LANGUAGE = 'en'

  class Config
    attr_accessor :dictionary
    attr_reader :severity
    
    # This is required by the service for caching purposes,
    # but no registration is needed (api_key should just be unique for
    # your app, only one request can happen per key at any moment).
    # There shouldn't be any need for this, but still
    attr_accessor :api_key
    # The language to use for this check
    # This is used to select the proper AtD server, unless overriden with the
    # :language option
    attr_accessor :language

    def initialize
      @dictionary = []
      @severity = {}
      ignore(Merimee::DEFAULT_IGNORE_TYPES)

      @api_key = Config.generate_api_key
      @language = Merimee::DEFAULT_LANGUAGE
    end

    def ignore(types)
      set_type_severity(types, :ignore)
    end
    def warn(types)
      set_type_severity(types, :warn)
    end
    def error(types)
      set_type_severity(types, :error)
    end
    def set_type_severity(types, level)
      unless types.kind_of?(Enumerable)
        types = [types]
      end
      types.each do |t|
        @severity[t.to_s.downcase] = level
      end
    end

    def dict_add(word)
      if word.kind_of?(String)
        @dictionary << word
      elsif word.kind_of?(Enumerable)
        @dictionary.concat word
      end
    end

    def dict_add_file(file)
      File.open(file) {|f| dict_add(f.readlines.map(&:strip)) }
    end

    def clone
      ret = Config.new
      ret.dictionary = @dictionary.dup
      ret.severity.update(@severity)
      ret.api_key = api_key
      ret.language = language
      ret
    end

    private
    # We just use the path to this file, and the current hostname
    # If you
    # This is probably not totally unique
    # We use the mac address and this file path, should be unique enough
    def self.generate_api_key
      data = [File.expand_path(__FILE__)]
      data << Mac.addr if defined?(Mac)
      Digest::SHA1.hexdigest(data.join)
    end
  end
end
