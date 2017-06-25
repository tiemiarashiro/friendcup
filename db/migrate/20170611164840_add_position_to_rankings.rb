class AddPositionToRankings < ActiveRecord::Migration[5.0]
  def change
    add_column :rankings, :position, :integer
  end
end
