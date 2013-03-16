class ApplicationController < ActionController::Base
  
  def authenticate_admin!
    true
  end
end