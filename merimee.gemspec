# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "merimee/version"

Gem::Specification.new do |s|
  s.name        = "merimee"
  s.version     = Merimee::VERSION
  s.authors     = ["atwam"]
  s.email       = ["wam@atwam.com"]
  s.homepage    = ""
  s.summary     = %q{Add spell checking to your views tests/specs}
  s.description = %q{Automatically submit your rendered views to AfterTheDeadline free spell check service, and make sure you don't have any errors in your views !}

  s.rubyforge_project = "merimee"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency 'crack'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rake'
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
