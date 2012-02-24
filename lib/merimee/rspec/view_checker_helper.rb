module Merimee
  module Rspec
    module ViewCheckerHelper
      RSpec::Matchers.define :have_a_correct_spelling do
        match do |rendered|
          checker = Merimee::Checker.new(::RSpec.configuration.merimee_config)

          if rendered
            @errors = checker.check(rendered)
            @errors.empty?
          else
            true
          end
        end
        failure_message_for_should do |view|
          errs = []
          @errors.each do |err|
            message = "[#{err.type}] #{err.string}"
            if err.suggestions
              message << " (suggested: #{err.suggestions.join(', ')})"
            end
            errs << message
          end
          errs.join("\n")
        end
      end

      def it_should_have_a_correct_spelling
        it "should have a correct spelling" do
          render
          rendered.should have_a_correct_spelling
        end
      end
    end
  end
end
