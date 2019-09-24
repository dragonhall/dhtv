Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :recordings

  get '/tv/index'

  resources :playlists do
    resources :tracks
  end

  root to: 'tv#index'
end
