class CreatePlaylists < ActiveRecord::Migration[7.1]
  def change
    create_table :playlists do |t|
      t.string :name
      t.integer :round_number
      t.string :spotify_url
      t.timestamps
    end
  end
end
