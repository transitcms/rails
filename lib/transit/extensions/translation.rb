module Transit
  module Extension
    module Translation
    ##
    # Block to process translatable fields. If translations are enabled
    # Mongoid::Globalize is enabled and attributes are parsed for translation.
    # If not, it is executed normally
    # 
    def with_optional_translation(&block)
      translates do
        block.call
      end
    end
    
    ##
    # Class method for enabling translations on any model
    # 
    def enable_translation
      begin
        include Mongoid::Globalize
      rescue LoadError
        raise "Missing the mongoid_globalize gem. Please add it to your gemfile to translate models"
      end
    end
    
    ##
    # Stub for translation functionality. 
    # This method is overridden with the functionality provided by Mongoid::Globalize
    # 
    def translates(&block)
      block.call
    end
    
    end # Translation
  end # Extension
end # Transit