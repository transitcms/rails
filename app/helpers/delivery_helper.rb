##
# Helper methods for delivering content 
# in your views.
# 
module DeliveryHelper
  
  ##
  # Takes a deliverable resource, loops through its contexts 
  # and returns the resulting output.
  # 
  def deliver(resource)
    Transit::Delivery.new(resource, self).deliver    
  end  
  
  def manage_delivery(resource, form, options = {})    
    Transit::Delivery.new(resource, self).manage(form, options)
  end
  
 
end