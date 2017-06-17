Rails.application.routes.draw do

  get 'ranking' => 'ranking#index'
  post 'championship/:id/atualizar_partidas' => 'championships#atualizar_partidas'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks", :registrations => 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'homes#index'

  resources :championships
end
