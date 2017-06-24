class CreateBrackets < ActiveRecord::Migration[5.0]
  def change
    create_table :brackets do |t|
      t.belongs_to :championship, :index => true
      t.belongs_to :player_1
      t.belongs_to :player_2
      t.belongs_to :winner
      t.integer :lft, :index => true
      t.integer :rgt, :index => true
      t.integer :parent_id, :index => true
    end
  end
end
