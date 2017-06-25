class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|
      t.references :user, foreign_key: true
      t.references :championship, foreign_key: true

      t.timestamps
    end
  end
end
