Bolao::Application.routes.draw do
  # Admin
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users
  
  get  '/palpites', to: 'guesses#my_guesses', as: :my_guesses
  post '/palpites', to: 'guesses#update',     as: :my_guesses_form
  delete '/palpites/reiniciar', to: 'guesses#destroy_all', as: :reset_my_guesses
  get  '/palpites/exportar', to: 'users#export_guesses', as: :export_my_guesses

  get  '/meu-historico',  to: 'users#history',      as: :my_history
  get  '/perfil/:id',     to: 'users#profile',      as: :user_profile

  get  '/jogo/:id',       to: 'matches#show',       as: :match_details

  get  '/regras', to: 'rules#index', as: :rules

  root to: 'dashboard#index'
end