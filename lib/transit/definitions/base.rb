module Transit
  module Definition
    ##
    # Base module/functionality for any type of deliverable
    # 
    module Base
      
      extend ActiveSupport::Concern
      
      included do
        
        # Stores the type of deliverable for this model
        class_attribute :delivers_as, :instance_writer => false

        # Stores a list of options for delivering this model
        class_attribute :delivery_options, :instance_writer => false
        self.delivery_options = ::ActiveSupport::OrderedOptions.new({
          :translate => Transit.config.enable_translations
        })

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
          field = self.contexts.detect do |context| 
            context.id.to_s === attrs['id'].to_s
          end
          field ||= self.send :build_context_by_specified_type, attrs
          field.attributes = attrs
        end
      end

      private

      def build_context_by_specified_type(attrs)
        sti_type = attrs.delete("_type")
        field = self.contexts.build(attrs, sti_type.classify.constantize)
        field.becomes(sti_type.classify.constantize)
      end
      
    end # Transit
  end # Definition
end # Deliverable