require "bundler/gem_tasks"
require "rspec"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new("spec") do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

task :default => :spec

task :serve => [:load_app] do
  `rackup -p 4000 spec/internal/config.ru`
  #Konacha.serve
end

task :mocha => [:load_app] do
  passed = Konacha.run
  exit 1 unless passed
end

task :load_app do
  ENV['TRANSIT_JS_ENV'] = "yes"
  require_relative "spec/spec_helper"
  module Konacha
    def self.spec_root
      File.join(File.dirname(__FILE__), "spec", "javascripts")
    end
  end
  class Konacha::Engine
    initializer "konacha.engine.environment", after: "konacha.environment" do
      Combustion::Application.config.assets.paths << Konacha.config.spec_dir
    end
  end
end