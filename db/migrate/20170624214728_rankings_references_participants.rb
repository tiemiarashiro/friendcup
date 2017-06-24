class RankingsReferencesParticipants < ActiveRecord::Migration[5.0]
  def change
    remove_reference(:rankings, :user)
    add_reference(:rankings, :participants, {index: true})
  end
end
