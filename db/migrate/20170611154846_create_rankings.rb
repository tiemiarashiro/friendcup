class CreateRankings < ActiveRecord::Migration[5.0]
  def change
    create_table :rankings do |t|
      t.references :user, foreign_key: true
      t.integer :played_games
      t.integer :scheduled_games
      t.integer :victories
      t.integer :draws
      t.integer :defeats
      t.integer :points

      t.timestamps
    end
  end
end
