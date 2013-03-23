if defined?(Konacha)
  Combustion::Application.config.cache_classes = false
  require 'coffee_script'
  Konacha.configure do |config|
    require 'capybara/poltergeist'
    require 'rspec/core/formatters/documentation_formatter'
    RSpec.configure do |conf|
      conf.color = true
    end
    config.spec_dir     = File.expand_path("../../../../javascripts", __FILE__)
    config.spec_matcher = /_spec\.|_test\./
    config.driver       = :poltergeist
    config.stylesheets  = %w(application)
  end
  
  module Konacha
    def self.spec_root
      File.expand_path("../../../../javascripts", __FILE__)
    end
  end
end