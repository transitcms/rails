Rails.application.routes.draw do  
  match '/transit(/*resource_url)' => "transit#manage", :as => :manage_resource
end