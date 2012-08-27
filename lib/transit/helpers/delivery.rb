module Transit
  module Helpers
    # ##
    # Helper methods for delivering content 
    # in your views.
    # 
    module Delivery
  
      ##
      # Takes a deliverable resource, loops through its contexts 
      # and returns the resulting output.
      # 
      def deliver(resource, options = {})    
        Transit::Delivery.new(resource, self, options).deliver
      end 
    end
  end
end