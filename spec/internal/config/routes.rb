Rails.application.routes.draw do
  mount Konacha::Engine => '/spec' if defined?(Konacha)
end
