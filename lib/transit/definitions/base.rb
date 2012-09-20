require 'ostruct'

module Transit
  module Definition
    ##
    # Base module/functionality for any type of deliverable.
    # Creates class attributes and relationships that all deliverable 
    # type classes should implement.
    # 
    module Base
      
      extend ActiveSupport::Concern
      
      included do
        
        # Stores the type of deliverable for this model
        class_attribute :delivers_as, :instance_writer => false, :instance_reader => true

        # Stores a list of options for delivering this model
        class_attribute :delivery_options, :instance_writer => false, :instance_reader => true
        
        ## Stub an attribute representing whether this specific class has translation support
        class_attribute :has_translation_support
        self.has_translation_support ||= false

        # All deliverables embed contexts which define the content each deliverable contains
        embeds_many :contexts, :as => :deliverable
        
        # Deliverables may have_many assets. 
        has_many :assets, :as => :deliverable
        
        # Override nested_attributes to ensure _type is properly set
        accepts_nested_attributes_for :contexts, :allow_destroy => true
        #alias :contexts_attributes= :build_context_attributes=
        
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
          field = self.contexts.detect do |context| 
            context.id.to_s === attrs['id'].to_s
          end
          
          field ||= self.contexts.create(attrs, (attrs.delete("_type") || 'context').classify.constantize)
          
          # We have to use update attributes because mongoid sometimes won't persist
          # translations on embededdd docs without it
          if field.respond_to?(:translations)
            field.update_attributes(attrs)
          else
            field.attributes = attrs
          end
        end
      end

      
    end # Transit
  end # Definition
end # Deliverable