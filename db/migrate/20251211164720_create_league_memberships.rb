class CreateLeagueMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :league_memberships do |t|
      t.references :league, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
