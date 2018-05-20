Rails.application.routes.draw do
  root to: 'sandboxes#index'

  get 'status', to: 'application#app_status'
  resources :sandboxes do
    post :deploy, on: :member
    get :file_contents, on: :member
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
