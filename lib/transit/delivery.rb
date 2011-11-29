module Transit
  ##
  # Manages delivery results for each available context. This allows easily customizing 
  # how a particular context is output into the page.
  # 
  # Deliveries are configured using the .configure class method, passing the name of the context 
  # class the delivery applies to, and a block specifying how to process the delivery. Each 
  # proc/lambda is passed 2 parameters, the first being the context to be delivered, the second is a 
  # reference to the current template object.  The resulting callback should return a string to be 
  # output into the page.
  # 
  class Delivery
    attr_reader :template
    class_attribute :delivery_methods
    self.delivery_methods ||= {} 
    
    class << self      
      def configure(name, &block)
        delivery_methods[name.to_s.underscore] = block
      end      
    end
    
    def initialize(tpl)
      @template = tpl
    end
    
    def deliver_context(context)
      klass = context.class.name.to_s.underscore
      raise "No delivery method defined for #{context.class.name}" unless delivery_methods[klass].present?
      delivery_methods[klass].call(context, template)
    end
    
  end # Delivery
end # Transit