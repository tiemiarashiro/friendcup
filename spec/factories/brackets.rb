FactoryGirl.define do
  factory :bracket do
    association :player_1, factory: :user
    association :player_2, factory: :user
    association :championship 
  end
end
