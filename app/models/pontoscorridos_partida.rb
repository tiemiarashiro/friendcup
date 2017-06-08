class PontoscorridosPartida < ApplicationRecord
  belongs_to :championship
  belongs_to :user, :foreign_key => 'player1'
  belongs_to :user, :foreign_key => 'player2'
end
