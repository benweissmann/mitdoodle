require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  test "option" do
    opt = create :option
    vote = create :vote, :option => opt
    assert_equal opt, vote.option
  end

  test "user association" do
    user = create :user
    vote = create :vote, :user => user
    assert_equal user, vote.user
  end

  test "poll" do
    poll = create :poll
    opt = create :option, :poll => poll
    vote = create :vote, :option => opt
    assert_equal poll, vote.poll
  end
end
