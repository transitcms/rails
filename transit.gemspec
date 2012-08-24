# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "transit/version"

Gem::Specification.new do |s|
  s.name        = "transit"
  s.version     = Transit::VERSION
  s.authors     = ["Brent Kirby"]
  s.email       = ["dev@kurbmedia.com"]
  s.homepage    = "https://github.com/transitcms/engine"
  s.summary     = %q{Transit is a content management and delivery engine designed for use with Rails 3.1+ MongoDB and Mongoid}
  s.description = %q{Transit is a content management and delivery engine designed for use with Rails 3.1+ MongoDB and Mongoid}

  s.rubyforge_project = "transit"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency("rails", ">= 3.1")
  s.add_dependency("mongoid", "~> 3.0.1")
  s.add_dependency("paperclip", "~> 3.1")
  s.add_dependency("mongoid-tree", "~> 1.0.0")
  
  s.add_development_dependency('combustion', '~> 0.3.1')
  s.add_development_dependency("rspec", ">= 2.11.0")
  s.add_development_dependency("rspec-rails", ">= 2.11.0")
  # s.add_development_dependency("rspec-rails-mocha", ">= 0.3.1")
  # s.add_development_dependency("mocha", ">= 0.10.0")
  s.add_development_dependency("machinist", "~> 2.0")
  # s.add_development_dependency("loofah", "~> 1.2")
  # s.add_development_dependency("nokogiri", ">= 1.4.4")
end
