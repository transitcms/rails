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
  
  s.add_dependency("mongo", "~> 2.4")  
  s.add_dependency("bson", "1.4.0")
  s.add_dependency("bson_ext", "1.4.0")
  s.add_dependency("mongoid", "~> 2.3")
  
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
