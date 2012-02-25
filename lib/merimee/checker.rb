# Main checker class
# Heavily inspired by the old AfterTheDeadline github repo
module Merimee
  class Checker
    attr_reader :config
    def initialize(config = nil)
      @config = config || Config.new
      yield @config if block_given?
    end

    def check(text, options = {})
      AfterTheDeadline.language = options[:language] || @config.language
      AfterTheDeadline.key = @config.api_key
      errors = AfterTheDeadline.check(text)
      
      # Remove spelling errors from our custom dictionary
      # Also remove stuff that is obviously not a word (AtD seems to have issues sometime)
      errors.reject! do |e|
        e.type == 'spelling' &&
          @config.dictionary.include?(e.string)
      end

      # Remove any error types we don't care about
      errors.each do |err|
        err.severity = @config.severity[err.description.downcase] || :error
      end

      errors
    end

  end

end
