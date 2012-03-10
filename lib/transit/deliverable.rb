require 'ostruct'

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
    
    
    class DeliveryOptions < ::OpenStruct
      
      def merge!(hash = {})
        hash.each_pair do |key, value|
          self.send(:"#{key.to_s}=", value)
        end
      end
      
      def reverse_merge!(hash = {})
        hash.each_pair do |key, value|
          next unless self.try(:"#{key.to_s}")
          self.new_ostruct_member(:"#{key.to_s}")
          self.send(:"#{key.to_s}=", value)
        end
      end
      
      private
      
      def add_or_update_method(name, value, overwrite = true)
        unless self.respond_to?(:"#{name.to_s}")
          self.new_ostruct_member(:"#{name.to_s}")
          self.send(:"#{name.to_s}=", value)
        end
        self.send(:"#{name.to_s}=", value) unless overwrite == false
      end
      
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
        
        self.delivery_options ||= Transit::Deliverable::DeliveryOptions.new(options.reverse_merge!(:translate => Transit.config.translate))

        self.delivers_as = type
        self.delivery_options.merge!(options)

        self.has_translation_support = !!self.delivery_options.translate
        
        unless Transit::Definition.const_defined?(type.to_s.classify)
          raise Transit::Definition::MissingDefinitionError
        end
        
        include Transit::Definition.const_get(type.to_s.classify)
        
        # register the deliverable class
        delivery = type.to_s.classify
        Transit.deliverables[delivery] ||= []
        Transit.deliverables[delivery] |= [self.name.to_s]
        
        Transit.run_definition_hooks(:"#{type.to_s}", self)
        
      end
   
    end # ClassMethods    
  end # Deliverable
end # Transit