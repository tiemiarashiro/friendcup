class Bracket < ApplicationRecord
  belongs_to :championship
  belongs_to :winner, class_name: 'User', required: false
  belongs_to :player_1, class_name: 'User'
  belongs_to :player_2, class_name: 'User'
  
  acts_as_nested_set
end