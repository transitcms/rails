require 'rubygems'
require 'bundler'
require 'bundler/setup'

# These environment variables can be set if wanting to test against a database
# that is not on the local machine.
ENV["TRANSIT_SPEC_HOST"] ||= "localhost"
ENV["TRANSIT_SPEC_PORT"] ||= "27017"

# These are used when creating any connection in the test suite.
HOST = ENV["TRANSIT_SPEC_HOST"]
PORT = ENV["TRANSIT_SPEC_PORT"]

Bundler.require :default, :development
require 'mongoid'

Mongoid.configure do |config|
  config.connect_to(ENV["CI"] ? "transitcms_test_#{Process.pid}" : "transitcms_test")
end

Mongoid.logger = nil

require 'simplecov'
SimpleCov.start 'rails'

require 'machinist'
require 'machinist/mongoid'

Combustion.initialize! :action_controller, :action_view, :sprockets, :action_mailer

ActiveSupport::Dependencies.explicitly_unloadable_constants << "Transit"
ActiveSupport::Dependencies.log_activity = true
  
# Avoid preloading models
require 'rails/mongoid'  
require 'rspec/rails'
require 'mongoid-rspec'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Mongoid::Matchers
  config.before(:each) do
    Mongoid.purge!
    Mongoid::IdentityMap.clear
  end
end