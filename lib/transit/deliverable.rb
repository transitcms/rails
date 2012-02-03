module Transit
  ##
  # Deliverable is the base module for all classes/models that are used for 
  # content delivery.
  # 
  module Deliverable
    
    extend ActiveSupport::Concern
    
    included do
      include Mongoid::Document
      include Mongoid::Timestamps
      include Mongoid::MultiParameterAttributes      
    end
    
    ##
    # Class level methods and functionality
    #
    module ClassMethods
      
      ##
      # Configures attributes and deliverable specific methods for the 
      # calling model. 
      #
      # @param [Symbol,String] type The type of deliverable. Each deliverable type is specified as a Transit::Definition
      # @param [Hash] options Any deliverable specific options
      # 
      def deliver_as(type, options = {})
        
        include Transit::Definition::Base
        
        self.delivers_as = type
        self.delivery_options.merge!(options)
        
        self.enable_translation if self.delivery_options.translate == true
        
        unless Transit::Definition.const_defined?(type.to_s.classify)
          raise Transit::Definition::MissingDefinitionError
        end
        
        include Transit::Definition.const_get(type.to_s.classify)        
        Transit.run_definition_hooks(:"#{type.to_s}", self)
        
      end
   
    end # ClassMethods    
  end # Deliverable
end # Transit