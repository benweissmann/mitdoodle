FactoryGirl.define do
  sequence(:username) {|n| "user#{n}" }

  factory :user do
    username { generate :username }
  end
end