module DeliveryHelper
  
  def deliver(resource)
    delivery_manager  = Transit::Delivery.new(resource, self)
    response = capture do
      resource.contexts.ascending(:position).each do |context|
        concat deliver_context(context, delivery_manager)
      end
    end
    response.html_safe
  end
  
  def deliver_context(context, manager = nil)
    if context.respond_to?(:deliver)
      content = context.deliver
      return content unless content === false
    end
    (manager ||= Transit::Delivery.new(context.deliverable, self)).deliver_context(context)
  end
  
end