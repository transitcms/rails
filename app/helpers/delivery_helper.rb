module DeliveryHelper
  
  def deliver(resource)
    delivery_manager  = Transit::Delivery.new(self)
    response = capture do
      resource.contexts.ascending(:position).each do |context|
        if context.respond_to?(:deliver)
          concat context.deliver
        else
          concat delivery_manager.deliver_context(context)
        end
      end
    end
    response.html_safe
  end
  
end