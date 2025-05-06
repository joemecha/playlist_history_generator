class CreateSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist
      t.string :album
      t.timestamps
    end

    add_index :songs, [:title, :artist], unique: true
  end
end
