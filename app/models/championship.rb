class Championship < ApplicationRecord

  belongs_to :championship_type
  belongs_to :user
  has_many :participants
  has_many :users, through: :participants
  
  accepts_nested_attributes_for :participants
  
end
