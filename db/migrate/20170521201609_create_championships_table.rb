class CreateChampionshipsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :championships do |t|
      t.string :name
      t.string :game
      t.belongs_to :user
      t.date :starts_at
      t.date :ends_at
    end
  end
end
