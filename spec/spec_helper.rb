require 'rubygems'
require 'bundler'
#require 'spork'
require 'bundler/setup'

Bundler.require :default, :development

#Spork.prefork do
  require 'machinist'
  require 'machinist/mongoid'
  
  Combustion.initialize! :action_controller, :action_view, :sprockets, :action_mailer
  # Combustion::Application.class_eval do
  #   config.cache_classes = false
  # end
  
  ActiveSupport::Dependencies.explicitly_unloadable_constants << "Transit"
  ActiveSupport::Dependencies.log_activity = true
  
  # Avoid preloading models
  require 'rails/mongoid'  
  
  #Spork.trap_class_method(Rails::Mongoid, :load_models)

  require 'rspec/rails'

  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

  RSpec.configure do |config|
    config.mock_with :mocha
    config.include Mongoid::Matchers
    config.after :suite do
      Mongoid.master.collections.select do |collection|
        collection.name !~ /system/
      end.each(&:drop)
    end
  end

# end
# 
# Spork.each_run do
#   Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
# end