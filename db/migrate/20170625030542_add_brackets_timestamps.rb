class AddBracketsTimestamps < ActiveRecord::Migration[5.0]
  def change
    change_table :brackets do |t|
      t.timestamps
    end
  end
end
