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
      
      # Stores the type of deliverable for this model
      class_attribute :delivers_as, :instance_writer => false

      # Stores a list of options for delivering this model
      class_attribute :delivery_options, :instance_writer => false
      
      # All deliverables embed contexts which define the content each deliverable contains
      embeds_many :contexts, :as => :deliverable
      
      # Override nested_attributes to ensure _type is properly set
      accepts_nested_attributes_for :contexts, :allow_destroy => true
      alias :contexts_attributes= :build_context_attributes=
      
    end
    
    ##
    # Because mongoid requires the class type be the last value in a build 
    # method, we override contexts_attributes= to ensure newly created contexts
    # are of the proper class.
    # 
    def build_context_attributes=(hash)
      hash.each_pair do |position, attrs|
        attrs.stringify_keys!
        next if attrs.empty?
        field = self.contexts.detect do |con| 
          con.id.to_s === attrs['id'].to_s
        end
        field ||= self.build_context_by_specified_type(attrs)
        field.attributes = attrs
      end
    end
    
    private
    
    def build_context_by_specified_type(attrs)
      sti_name = self.class.inheritance_column.to_s
      sti_type = attrs.delete(sti_name)
      field    = self.build_context(attrs)
      field.write_attribute(sti_name, sti_type)
      field = field.becomes(sti_type.classify.constantize) if field.respond_to?(:becomes)
      field
    end
    
    module ClassMethods
      
      ##
      # Configures attributes and deliverable specific methods for the 
      # calling model. 
      #
      # @param [Symbol,String] type The type of deliverable. Each deliverable type is specified as a Transit::Definition
      # @param [Hash] options Any deliverable specific options
      # 
      def deliver_as(type, options = {})
        self.delivers_as = type
        self.delivery_options = ::ActiveSupport::OrderedOptions.new(options)
        unless Transit::Definition.const_defined?(type.to_s.classify)
          raise Transit::Definition::MissingDefinitionError
        end
        include Transit::Definition.const_get(type.to_s.classify)        
        Transit.run_definition_hooks(:"#{type.to_s}", self)
      end
      
      ##
      # Deliverables can include a number of other packages and 
      # delivery options. To include them pass them to this method.
      #
      # @param [Array] *args Argument list of packages/plugins to apply to the deliverable 
      #
      def deliver_with(*args)
        
      end
      
      
    end # ClassMethods    
  end # Deliverable
end # Transit