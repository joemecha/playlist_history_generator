Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :playlists, only: [:index] do
    collection do
      post :scrape
      post :import_songs
    end
  end

  resources :songs, only: [:index] do
    collection do
      post :import
    end
  end
end
