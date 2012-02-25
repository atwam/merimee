require "merimee/version"

require "merimee/checker"
require "merimee/config"
require "merimee/error"
require "merimee/after_the_deadline"

require 'merimee/railties/merimee_railtie.rb' if defined?(Rails)

if defined?(::RSpec) && defined?(::RSpec::Rails::ViewExampleGroup)
  require 'merimee/rspec/view_checker_helper.rb'

  ::RSpec.configure do |config|
    config.add_setting :merimee_config, :default => Merimee::Config.new
    #config.merimee_config = Merimee::Config.new
    config.extend Merimee::RSpec::ViewCheckerHelper
  end
end

module Merimee
end
