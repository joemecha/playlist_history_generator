class AddSpotifyCreatedAtToPlaylists < ActiveRecord::Migration[7.1]
  def change
    add_column :playlists, :spotify_created_at, :datetime
  end
end
