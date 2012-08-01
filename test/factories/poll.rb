FactoryGirl.define do
  sequence(:poll_title) {|n| "Poll #{n}" }
  sequence(:poll_desc) {|n| "This is a description for poll #{n}"}

  factory :poll do
    user

    title      { generate :username }
    closed     false
    key        { ActiveSupport::SecureRandom.hex(15) }
    short_link "http://goo.gl/short_link"
    anon       false
  end
end