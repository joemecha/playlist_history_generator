class MakeLeagueIdNotNullOnPlaylists < ActiveRecord::Migration[7.1]
  def change
    change_column_null :playlists, :league_id, false
  end
end
