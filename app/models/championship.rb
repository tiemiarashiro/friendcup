class Championship < ApplicationRecord

  belongs_to :user
  belongs_to :championship_type
  
end
