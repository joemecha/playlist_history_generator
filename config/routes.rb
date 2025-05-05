Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :playlists, only: [:index] do
    collection do
      post :scrape
    end
  end
end
