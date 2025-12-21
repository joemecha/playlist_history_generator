Rails.application.routes.draw do
  devise_for :users

  root to: "songs#index"
  get "up" => "rails/health#show", as: :rails_health_check

  resources :leagues, only: [:index]
  
  resources :playlists, only: [:index] do
    collection do
      post :scrape
    end

    member do
      patch :update_spotify_created_at
      post :import_songs
    end
  end

  resources :songs, only: [:index] do
    collection do
      post :import # bulk import
      get :export_csv
    end
  end

  resources :stats, only: [:index]

  namespace :admin do
    resources :leagues
    resources :users, only: [:index] do
      patch :toggle_admin, on: :member
    end
  end
end
