module Merimee
  module Rspec
    module ViewCheckerHelper
      class HaveACorrectSpellingMatcher
        def initialize
          @config = ::RSpec.configuration.merimee_config
          yield @config if block_given?
        end

        def matches?(rendered)
          checker = Merimee::Checker.new(@config)

          if rendered
            @errors = checker.check(rendered)
            @errors.none? {|e| e.severity == :error}
          else
            true
          end
        end

        def failure_message_for_should
          errs = []
          @errors.sort_by(&:severity).each do |err|
            message = "[#{err.severity} : #{err.type} - #{err.description}] #{err.string}"
            unless err.suggestions.empty?
              message << " (suggested: #{err.suggestions.join(', ')})"
            end
            errs << message
          end
          errs.join("\n")
        end
      end

      def it_should_have_a_correct_spelling(&block)
        it "should have a correct spelling" do
          render
          rendered.should HaveACorrectSpellingMatcher.new(&block)
        end
      end
    end
  end
end
