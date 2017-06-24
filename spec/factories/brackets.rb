FactoryGirl.define do
  factory :bracket do
    association :player_1, factory: :participant
    association :player_2, factory: :participant
    association :championship 
  end
end
