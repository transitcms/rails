class Transit::ContextsController < TransitController  
  before_filter :fail_on_missing_deliverable
  helper_method :deliverable, :collection, :context
  
  respond_to *Transit.config.response_formats
  
  def index
    respond_with(collection)
  end
  
  def context
    deliverable.contexts.find(params[:id])
  end
  
  def collection
    deliverable.contexts
  end
  
  def deliverable
    @deliverable ||= lookup_deliverable
  end
  
  protected
  
  ##
  # Takes the :deliverable and :deliverable_id
  # params and finds the resulting model.
  # 
  def lookup_deliverable
    klass = params[:deliverable].classify.constantize
    begin
      klass.find(params[:deliverable_id]) 
    rescue 
      nil
    end
  end
  
  ##
  # If the deliverable could not be found. Render a 404
  # 
  def fail_on_missing_deliverable
    render :text => '', :status => 404 and return if deliverable.nil?
  end
end