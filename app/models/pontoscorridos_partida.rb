class PontoscorridosPartida < ApplicationRecord
  belongs_to :championship
  belongs_to :player1, :foreign_key => 'player1', class_name: 'Participant'
  belongs_to :player2, :foreign_key => 'player2', class_name: 'Participant'
end
