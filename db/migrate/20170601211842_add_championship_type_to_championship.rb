class AddChampionshipTypeToChampionship < ActiveRecord::Migration[5.0]
  def change
    add_reference :championships, :championship_type, foreign_key: true
  end
end
