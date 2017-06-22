FactoryGirl.define do
  factory :championship do
    association :user
    association :championship_type
  end
end
