class DeleteNestedSetColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :brackets, :lft
    remove_column :brackets, :rgt
  end
end
