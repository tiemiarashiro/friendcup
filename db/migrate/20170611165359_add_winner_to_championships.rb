class AddWinnerToChampionships < ActiveRecord::Migration[5.0]
  def change
    add_column :championships, :winner, :integer
  end
end
