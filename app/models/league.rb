class League < ApplicationRecord
  has_many :playlists, dependent: :destroy
end
