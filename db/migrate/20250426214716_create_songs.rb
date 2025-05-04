class CreateSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist
      t.string :album
      t.references :playlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
