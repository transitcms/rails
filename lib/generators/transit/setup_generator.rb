module Transit
  module Generators
    ##
    # Generates a configuration initializer in config/initializers 
    # including documentation and default options.
    # 
    class SetupGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      def copy_initializer
        template "transit.rb", "config/initializers/transit.rb"
      end
    end
    
  end
end