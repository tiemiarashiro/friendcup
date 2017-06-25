FactoryGirl.define do
  factory :participant do
    association :user
    association :championship
  end
end
