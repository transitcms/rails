module Transit
  module Extension
    ##
    # Many objects such as contexts and menu items use an ordering system 
    # based on a position attribute. This module mixes in that functionalty.
    # 
    module Ordering
      extend ActiveSupport::Concern
      
      included do
        class_attribute :method_for_position_counter
        
        before_create :set_default_position
        field :position, :type => Integer
        default_scope ascending(:position)
      end
      
      ##
      # Move an item to a particular position, moving 
      # items "after" this to a higher position
      # 
      def reposition!(index)
        target     = get_object_for_position_counter
        collection = nil
        counting   = index
        
        if index > target.count
          index      = target.count
          counting   = 0
          collection = target.lte(:position => index)
        elsif index <= 0
          index = 1
          counting = 1
        end
        
        collection = collection || target.gte(:position => index)
        collection.each do |item|
          next if item.id == self.id
          counting = counting + 1
          item.set(:position, counting)
        end
        self.set(:position, index)
      end
      
      private
      
      ##
      # On create, new items are added to the bottom of the 'stack'.
      # Ordered items are always output in ascending order by their position.
      #       
      def set_default_position
        self.position ||= (get_object_for_position_counter.count.to_i + 1)
        true
      end
      
      ##
      # Gets a target for calculating position values
      # 
      def get_object_for_position_counter
        target = self.method_for_position_counter
        return self.send(target) if target
        self._parent.send(self.metadata.name)
      end
      
    end # Ordering
  end # Extensions
  # 
end # Transit