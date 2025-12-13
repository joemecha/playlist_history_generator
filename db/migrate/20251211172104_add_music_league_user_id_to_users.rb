class AddMusicLeagueUserIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :music_league_user_id, :string
    add_index :users, :music_league_user_id
  end
end
