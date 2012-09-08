module Transit
  module Extension
    ##
    # Many objects such as contexts and menu items use an ordering system 
    # based on a position attribute. This module mixes in that functionalty.
    # 
    module Ordering
      extend ActiveSupport::Concern
      
      included do
        after_create :set_default_position
        field :position, :type => Integer
        default_scope ascending(:position)
      end
      
      ##
      # On create, new items are added to the bottom of the 'stack'.
      # Ordered items are always output in ascending order by their position.
      #       
      def set_default_position
        self.set('position', self._parent.send(self.metadata.name).count.to_i)
      end
      
    end # Ordering
  end # Extensions
  # 
end # Transit