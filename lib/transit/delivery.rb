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
    attr_reader :template, :resource, :options

    ##
    # Create a new delivery instance for the 
    # provided resource.
    # @param [Object] instance A deliverable class/object
    # @param [Object] tpl The current instance of a view or template
    # 
    def initialize(instance, tpl, opts = {})
      @template = tpl
      @resource = instance
      @options  = opts
      self
    end
    
    ##
    # Loops through each context within a resource, and performs its delivery, returning 
    # the final output.
    # 
    # Deliveries can be defined in one of three ways:
    #   1. By adding a .deliver method to a context. Unless this method explicitly returns `false` 
    #      the result of this method will be used.
    #   2. Creating a partial under app/views/transit/contexts/_context_name.html.erb (ie: _audio.html.erb)
    #   3. Configuring a deliverable block via Transit::Delivery.configure 
    #
    def deliver
      
      # Support delivering only a single context
      if ::Context.descendants.include?(resource.class)
        rendered = deliver_context(resource)
        rendered = deliver_managed_context(resource, rendered) if managed?
        return rendered
      end
      raise UndeliverableResourceError.new("The class #{resource.class.name} is not deliverable.") unless resource.respond_to?(:contexts)
      
      response = template.capture do
        resource.contexts.ascending(:position).each do |context|          
          rendered = deliver_context(context)
          rendered = deliver_managed_context(context, rendered) if managed?
          template.concat(rendered)
        end
      end
      response.to_s.html_safe
    end
    
    ##
    # Should this context be output in a managed state?
    # 
    def managed?
      (options[:managed].present? && options[:managed] === true)
    end
 
    private
    
    def form
      (options[:form] || nil)
    end
    
    ##
    # Delivers a context based on its deliverable method
    #
    def deliver_context(context)
      template_name = managed? ? "manage" : "show"
      
      if context.respond_to?(:deliver) && !managed?
        content = context.deliver
        return content unless content === false
      end
      
      klass = context.class.name.to_s.underscore
      
      begin
        return template.capture do
          template.render(:template => "#{klass}/#{template_name}", :locals => { :context => context })
        end
      rescue ActionView::MissingTemplate
        raise UndeliverableContextError.new("No partial found for #{context.class.name}. Expected app/contexts/#{klass}/#{template_name}.:format")
      end
    end
    
    ##
    # Output a context in a managed state
    # 
    def deliver_managed_context(context, content)
      klasses = ['managed-context', context.context_type.underscore.dasherize].join(" ")
      template.content_tag(:div, content, :class => klasses, :data => { 'context-id' => context.id.to_s, 'context-type' => context.context_type })
    end

  
    ##
    # Raised when a delivery method cannot be found for an object
    #
    class UndeliverableContextError < ::Transit::Error      
    end
    
    ##
    # Raised when a resource is passed that is not a deliverable
    #
    class UndeliverableResourceError < ::Transit::Error      
    end
    
  end # Delivery
end # Transit