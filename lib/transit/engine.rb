require 'transit'

module Transit
  ##
  # Ties into the Rails application.
  # 
  class Engine < Rails::Engine
    config.transit = Transit.config
    paths['app/models'] << File.expand_path("../../../app/models/contexts", __FILE__)

    initializer "transit.enable_translations", :before => :eager_load! do
      require 'mongoid'
      Mongoid::Document::ClassMethods.class_eval do
        include Transit::Extension::Loader
        include Transit::Extension::Translations
      end
    end
    
  end
end