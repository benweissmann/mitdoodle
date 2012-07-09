require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "votes" do
    user = create :user
    votes = (1..3).map { create :vote, :user => user }

    assert_equal votes.to_set, user.votes.to_set
  end

  test "votes destroyed when user destroyed" do
    user = create :user
    votes = (1..3).map { create :vote, :user => user }

    user.destroy

    votes.each do |vote|
      assert_raise(ActiveRecord::RecordNotFound) { Vote.find vote.id }
    end
  end

  test "polls" do
    user = create :user
    polls = (1..3).map { create :poll, :user => user }

    assert_equal polls.to_set, user.polls.to_set
  end
end
