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

Mongoid.load!(File.join(File.dirname(__FILE__), 'internal', 'config', 'mongoid.yml'))

Mongoid.logger = nil

require 'simplecov'
SimpleCov.start 'rails'

require 'machinist'
require 'machinist/mongoid'

if ENV['TRANSIT_JS_ENV']
  require 'konacha'
end

Combustion.initialize! :action_controller, :action_view, :sprockets, :action_mailer

ActiveSupport::Dependencies.explicitly_unloadable_constants << "Transit"
ActiveSupport::Dependencies.log_activity = true
  
# Avoid preloading models
require 'rails/mongoid'  
require 'rspec/rails'
require 'mongoid-rspec'
require 'rspec-html-matchers'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.color = true
  config.mock_with :rspec
  config.include Mongoid::Matchers
  config.before(:each) do
    Mongoid.purge!
    Mongoid::IdentityMap.clear
  end
  config.after(:suite) do
    Asset.destroy_all
  end
end