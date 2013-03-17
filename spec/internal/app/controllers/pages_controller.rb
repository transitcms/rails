class PagesController < ApplicationController
  helper_method :resource
  layout :transit_layout
  
  def show
    @page = Page.new
    @page.contexts.build({ body: "Page Heading", node: "h1" }, HeadingText)
    render action: :show
  end
  
  protected
  
  def transit_layout
    return "transit" unless params[:transit_managed].present?
    'application'
  end
  
  def resource
    @page
  end
end