class TransitController < ApplicationController
  layout false
  before_filter :run_authentication_method, only: :manage
  
  ##
  # Handles managing a resource by rendering the 
  # management view, with iframe. 
  # 
  def manage
    render text: '', layout: "transit"
  end
  
  protected
  ##
  # Runs the configured authentication method on the controller
  # to restrict access. Skips if the method is nil or missing.
  # 
  def run_authentication_method
    method = ::Transit.config.authentication_method
    return true unless method
    send(method)
  end
end