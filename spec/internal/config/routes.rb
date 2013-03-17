Rails.application.routes.draw do
  
  resources :pages
  mount Konacha::Engine => '/spec' if defined?(Konacha)
  
end
