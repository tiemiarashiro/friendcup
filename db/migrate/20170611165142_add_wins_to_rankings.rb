class AddWinsToRankings < ActiveRecord::Migration[5.0]
  def change
    add_column :rankings, :wins, :integer
  end
end
