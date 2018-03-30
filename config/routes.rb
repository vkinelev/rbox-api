Rails.application.routes.draw do
  resources :sandboxes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'docker_registry_notifications', to: 'docker_registry_notifications#handle'
end
