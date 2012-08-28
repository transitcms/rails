Rails.application.routes.draw do  
  namespace :transit do
    resources :contexts
    resources :templates, :only => [:show] do
      get 'manage', :on => :member
    end
  end
end