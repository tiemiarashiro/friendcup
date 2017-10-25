class CreateInterests < ActiveRecord::Migration[5.0]
  def change
    create_table :interests do |t|
      t.belongs_to :user, :index => true
      t.string :format
      t.string :local
      t.datetime :datetime
    end
  end
end
