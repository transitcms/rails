##
# Helper methods for delivering content 
# in your views.
# 
module DeliveryHelper
  
  ##
  # Takes a deliverable resource, loops through its contexts 
  # and returns the resulting output.
  # 
  def deliver(resource, options = {})    
    Transit::Delivery.new(resource, self, options).deliver
  end 
 
end