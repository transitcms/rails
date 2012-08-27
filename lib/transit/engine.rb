require 'transit'

module Transit
  ##
  # Ties into the Rails application.
  # 
  class Engine < Rails::Engine
    config.transit = Transit.config
    
    paths['app/models'] << File.expand_path("../../../app/models/contexts", __FILE__)
    paths['app/views'] << File.expand_path("../../../app/contexts", __FILE__)
    
    initializer "transit.enable_extensions", :before => :eager_load! do
      require 'mongoid'      
      Mongoid::Document::ClassMethods.class_eval do
        include Transit::Extension::Loader
      end
    end
    
    initializer 'transit.view_autoload', :before => :set_autoload_paths do |app|
      app.config.autoload_paths << Rails.root + 'app/contexts'
    end
    
    ActiveSupport.on_load(:action_controller) do
      append_view_path Transit.template_base_path || File.join(Rails.root, 'app', 'contexts')
    end

    initializer "transit.preload_contexts" do |app|
      transit_dir = File.expand_path("../../../app/models/contexts", __FILE__)
      config.to_prepare do
        Dir.glob(File.join(transit_dir, '*.rb')).each do |file|
          require_dependency(file)
        end
        
        begin
          Dir.glob(File.join(Rails.root, 'app', 'models', 'contexts', '*.rb')).each do |file|
            require_dependency(file)
          end
        rescue
        end
      end
    end
  end
end