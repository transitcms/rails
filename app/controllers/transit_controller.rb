class TransitController < ApplicationController
  before_filter :run_authentication_method
  
  protected
  ##
  # Runs the configured authentication method on the controller
  # to restrict access. Skips if the method is nil or missing.
  # 
  def run_authentication_method
    method = Transit.config.authentication_method
    return true unless method
    send(method)
  end
end