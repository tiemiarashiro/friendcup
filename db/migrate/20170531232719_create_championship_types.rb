class CreateChampionshipTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :championship_types do |t|
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
