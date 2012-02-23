module Merimee
  class Railtie < ::Rails::Railtie
    rake_tasks do
      require 'path/to/railtie.tasks'
    end
  end
end
