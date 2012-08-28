class Transit::TemplatesController < TransitController
  layout false
  helper_method :context
  
  def show
    render :template => "#{template_name}/show", :handlers => [Transit.config.template_handler], :formats => [:html]
  end
  
  def manage
    render :template => "#{template_name}/manage", :handlers => [Transit.config.template_handler], :formats => [:html]
  end
  
  def context
    @context ||= generate_context
  end
  
  protected
  
  def template_name
    params[:id].to_s.underscore
  end
  
  ##
  # Stub a new instance of a context.
  # 
  def generate_context
    klass = params[:id].classify.constantize
    if params[:context_id].present?
      return klass.find(params[:context_id])
    end
    klass.new
  end
end