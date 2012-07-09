FactoryGirl.define do
  sequence(:option_label) {|n| "Option #{n}" }
  factory :option do
    poll

    label { generate :option_label }

    factory :option_with_votes do
      ignore do
        yes_votes 5
        no_votes  5
      end

      after(:create) do |option, evaluator|
        FactoryGirl.create_list :vote, evaluator.yes_votes, :option => option, :yes => true
        FactoryGirl.create_list :vote, evaluator.no_votes, :option => option, :yes => false
      end
    end
  end
end