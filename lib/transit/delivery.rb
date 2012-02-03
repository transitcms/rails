module Transit
  ##
  # Manages delivery results for each available context. This allows easily customizing 
  # how a particular context is output into the page.
  # 
  # Deliveries are configured using the .configure class method, passing the name of the context 
  # class the delivery applies to, and a block specifying how to process the delivery. Each 
  # proc/lambda is passed the context to be delivered, and is evaluated in the scope of the current view.
  # 
  class Delivery
    attr_reader :template, :resource
    class_attribute :delivery_methods
    self.delivery_methods ||= ::ActiveSupport::HashWithIndifferentAccess.new
    
    class << self
      ##
      # Stores a delivery/resource block for a particular context.
      # When a resource is delivered, this block is used to format
      # the resulting content.
      # 
      # When called the block is executed in the scope of the current view / template 
      # so all helpers are readily available.
      # 
      # @param [String,Symbol] name The name of the context to configure
      # @param [Proc] block The proc to be called when generating output
      # 
      # @example Store a block for an audio context, which calls Rails' audio_tag
      #   Transit::Delivery.configure(:audio) do |context|
      #     audio_tag(context.source)
      #   end
      # 
      def configure(name, &block)
        delivery_methods[name.to_s.underscore] = block
      end  
      alias :register :configure    
    end
  
    ##
    # Create a new delivery instance for the 
    # provided resource.
    # @param [Object] instance A deliverable class/object
    # @param [Object] tpl The current instance of a view or template
    # 
    def initialize(instance, tpl)
      @template = tpl
      @resource = instance
      self
    end
    
    ##
    # Loops through each context within a resource, and performs its delivery, returning 
    # the final output.
    # 
    # Deliveries can be defined in one of two ways:
    #   1. By adding a .deliver method to a context. Unless this method explicitly returns `false` 
    #      the result of this method will be used.
    #   2. Configuring a deliverable block via Transit::Delivery.configure
    #
    def deliver
      # Support delivering only a single context
      if ::Context.descendants.include?(resource.class)
        return deliver_context(resource)
      end
      response = template.capture do
        resource.contexts.ascending(:position).each do |context|          
          template.concat(deliver_context(context))
        end
      end
      response.html_safe
    end
    
    
    private
    
    ##
    # Delivers a context based on its deliverable method
    #
    def deliver_context(context)
      if context.respond_to?(:deliver)
        content = context.deliver
        return content unless content === false
      end
      klass = context.class.name.to_s.underscore
      raise UndeliverableContextError.new("No delivery method defined for #{context.class.name}") unless delivery_methods[klass].present?
      template.instance_exec(context, &delivery_methods[klass])
    end
  
    ##
    # Raised when a delivery method cannot be found for an object
    #
    class UndeliverableContextError < ::Transit::Error      
    end
    
  end # Delivery
end # Transit