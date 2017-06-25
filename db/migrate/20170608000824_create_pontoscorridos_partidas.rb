class CreatePontoscorridosPartidas < ActiveRecord::Migration[5.0]
  def change
    create_table :pontoscorridos_partidas do |t|
      t.references :championship, foreign_key: true
      t.integer :player1
      t.integer :player2
      t.integer :score_player1
      t.integer :score_player2

      t.timestamps
    end
  end
end
