class AddLeagueToPlaylists < ActiveRecord::Migration[7.1]
  def change
    add_reference :playlists, :league, null: true, foreign_key: true
  end
end
