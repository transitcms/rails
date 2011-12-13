module Transit
  ##
  # Manages delivery results for each available context. This allows easily customizing 
  # how a particular context is output into the page.
  # 
  # Deliveries are configured using the .configure class method, passing the name of the context 
  # class the delivery applies to, and a block specifying how to process the delivery. Each 
  # proc/lambda is passed 2 parameters, the first being the context to be delivered, the second is a 
  # reference to the active instance of the delivery class.  The resulting callback should return a string to be 
  # output into the page.
  # 
  class Delivery
    attr_reader :template, :resource
    class_attribute :delivery_methods
    self.delivery_methods ||= ::ActiveSupport::HashWithIndifferentAccess.new
    
    class << self      
      def configure(name, &block)
        delivery_methods[name.to_s.underscore] = block
      end      
    end
  
    
    def initialize(instance, tpl)
      @template = tpl
      @resource = instance
      self
    end
    
    def deliver_context(context)
      klass = context.class.name.to_s.underscore
      raise Undeliverable.new("No delivery method defined for #{context.class.name}") unless delivery_methods[klass].present?
      delivery_methods[klass].call(context, self)
    end
    
    def method_missing(method, *args)
      if template.respond_to?(method)
        self.class_eval do
          delegate method, :to => :template
        end
        return template.send(method, *args)
      end
      super
    end
   
    class UndeliverableContextError < ::Transit::Error      
    end
    
  end # Delivery
end # Transit