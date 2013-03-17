require 'rubygems'
require 'bundler'

Bundler.require :default, :development

if ENV['TRANSIT_JS_ENV']
  ENV['RACK_ENV'] = "development"
  ENV['RAILS_ENV'] = "development"
  require 'konacha'
end

require 'combustion'
require 'sass-rails'
require 'coffee-rails'
require 'bootstrap-sass'

Combustion.initialize! :action_controller, :action_view, :sprockets, :action_mailer
run Combustion::Application