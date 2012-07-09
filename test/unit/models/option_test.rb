require 'test_helper'

class OptionTest < ActiveSupport::TestCase
  test "votes" do
    opt = create :option
    votes = (1..3).map { create :vote, :option => opt }

    assert_equal votes.to_set, opt.votes.to_set
  end

  test "votes destroyed when option destroyed" do
    opt = create :option
    votes = (1..3).map { create :vote, :option => opt }

    opt.destroy

    votes.each do |vote|
      assert_raise(ActiveRecord::RecordNotFound) { Vote.find vote.id }
    end
  end

  test "users" do
    opt = create :option
    votes = (1..3).map { create :vote, :option => opt }

    assert_equal votes.map(&:user).to_set, opt.users.to_set
  end

  test "poll" do
    poll = create :poll
    opt = create :option, :poll => poll
    assert_equal poll, opt.poll
  end

  test "yes vote count" do
    opt = create :option
    # create 3 yes votes and 4 no votes
    3.times { create :vote, :option => opt, :yes => true }
    4.times { create :vote, :option => opt, :yes => false }
    assert_equal 3, opt.yes_votes_count

    opt = create :option
    # 0 votes
    assert_equal 0, opt.yes_votes_count

    opt = create :option
    # all no votes
    3.times { create :vote, :option => opt, :yes => false }
    assert_equal 0, opt.yes_votes_count
  end

  test "delete votes after update" do
    opt = create :option

    3.times { create :vote, :option => opt}

    assert_equal 3, opt.votes.size

    opt.label = 'foo'
    opt.save!

    assert_equal 0, opt.votes.reload.size
  end
end
