require "merimee/version"

require "merimee/checker"
require "merimee/config"
require "merimee/error"
require "merimee/after_the_deadline"

require 'merimee/railties/merimee_railtie.rb' if defined?(Rails)

if defined?(RSpec) && defined?(RSpec::Matchers)
  require 'merimee/rspec/view_checker_helper.rb'
  RSpec.configuration.add_setting :merimee_config

  RSpec.configure do |config|
    config.merimee_config = Merimee::Config.new
    config.extend Merimee::Rspec::ViewCheckerHelper
  end
end

module Merimee
end
