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
    # Deliveries can be defined in one of three ways:
    #   1. By adding a .deliver method to a context. Unless this method explicitly returns `false` 
    #      the result of this method will be used.
    #   2. Creating a partial under app/views/transit/contexts/_context_name.html.erb (ie: _audio.html.erb)
    #   3. Configuring a deliverable block via Transit::Delivery.configure 
    #
    def deliver
      # Support delivering only a single context
      if ::Context.descendants.include?(resource.class)
        return deliver_context(resource)
      end
      raise UndeliverableResourceError.new("The class #{resource.class.name} is not deliverable.") unless resource.respond_to?(:contexts)
      response = template.capture do
        resource.contexts.ascending(:position).each do |context|          
          template.concat(deliver_context(context))
        end
      end
      response.html_safe
    end
    
    
    ##
    # Similar to deliver above, but instead of outputing content, 
    # it outputs fields for managing / editing context data.
    # 
    # Management templates are partials located under transit/contexts and use the naming format `_manage_context_name.html.erb`
    # For instance, the partial to manage an audio context would be saved under app/views/transit/contexts/_manage_audio.html.erb
    # 
    # When managing a resource, contexts are output using an ordered list, where the items are comprised of each context to be managed.
    # This allows for easy sorting of contexts by position.
    #
    # @param [Object] form A form_for or fields_for (when managing single contexts) instance for the deliverable's form.
    # @param [Hash] options A hash of html attributes to be passed to the containing list
    # 
    def manage(form, options = {})
      if ::Context.descendants.include?(resource.class)        
        return manage_context(resource, form)
      end
      raise UndeliverableResourceError.new("The class #{resource.class.name} could not be managed.") unless resource.respond_to?(:contexts)      
      
      options.reverse_merge!(:id => "managed_deliverable_#{resource.id.to_s}")
      
      klasses = options.delete(:class) || ""
      klasses = klasses.split(" ").push("managed-deliverable")
      options.merge!(:class => klasses.join(" "))
      
      options[:data] = options.delete(:data) || {}
      options[:data].merge!(:deliverable_id => resource.id.to_s, :deliverable_type => resource.class.name.to_s)
      
      response = template.capture do
        template.content_tag(:ol, options) do
          form.fields_for(:contexts) do |f|
            manage_context(f.object, f)
          end
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
      begin
        return template.capture do
          template.render(:partial => "transit/contexts/#{klass}", :locals => { :context => context })
        end
      rescue ActionView::MissingTemplate
        raise UndeliverableContextError.new("No partial found for #{context.class.name}. Expected app/views/transit/contexts/_#{klass}.html.erb")
      end
    end
    
    ##
    # Outputs a context in its managed state.
    # 
    def manage_context(context, form)
      klass = context.class.name.to_s.underscore
      begin
        content = template.capture do
          template.render(:partial => "transit/contexts/manage_#{klass}", :locals => { :f => form, :form => form, :context => context }) <<
          (context.persisted? ? form.hidden_field(:id) : "") <<
          form.hidden_field(:_type, { :value => context.class.name.to_s }) <<
          form.hidden_field(:position, { :value => context.position.to_i, :rel => "position" })
        end
        return template.content_tag(:li, content, { :class => "manage-context #{klass.dasherize}-context", :data => { :context_id => context.id.to_s } })
      rescue
        raise UndeliverableContextError.new("No partial found for #{context.class.name}. Expected app/views/transit/contexts/_manage_#{klass}.html.erb")
      end
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