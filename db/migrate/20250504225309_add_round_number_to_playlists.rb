class AddRoundNumberToPlaylists < ActiveRecord::Migration[7.1]
  def change
    add_column :playlists, :round_number, :integer
  end
end
