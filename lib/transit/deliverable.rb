module Transit
  ##
  # Deliverable is the base module for all classes/models that are used for 
  # content delivery.
  # 
  module Deliverable
    
    extend ActiveSupport::Concern
    
    included do
      include Mongoid::Timestamps
      include Mongoid::MultiParameterAttributes
      
      # Stores the type of deliverable for this model
      class_attribute :delivers_as, :instance_writer => false

      # Stores a list of options for delivering this model
      class_attribute :delivery_options, :instance_writer => false
      
      # All deliverables embed contexts which define the content each deliverable contains
      embeds_many :contexts, :as => :deliverable
            
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