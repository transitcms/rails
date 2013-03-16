require 'rubygems'
require 'bundler'

Bundler.require :default, :development

if ENV['TRANSIT_JS_ENV']
  require 'konacha'
end

Combustion.initialize! :action_controller, :action_view, :sprockets, :action_mailer
run Combustion::Application