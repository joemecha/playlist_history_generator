class AddLeagueIdAndUrlToLeague < ActiveRecord::Migration[7.1]
  def change
    add_column :leagues, :music_league_id, :string
    add_column :leagues, :url, :string

    add_index :leagues, :music_league_id, unique: true
  end
end
