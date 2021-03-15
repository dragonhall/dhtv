# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :recordings

  get '/tv/index'
  get '/tv/banner'

  get '/tv/current', to: 'tracks#current'

  resources :playlists do
    resources :tracks
  end

  root to: 'tv#index'
end
