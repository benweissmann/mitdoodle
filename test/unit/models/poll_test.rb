require 'test_helper'

class PollTest < ActiveSupport::TestCase
  test "options" do
    poll = create :poll
    opts = (1..3).map { create :option, :poll => poll }

    assert_equal opts.to_set, poll.options.to_set
  end

  test "options destroyed when poll destroyed" do
    poll = create :poll
    opts = (1..3).map { create :option, :poll => poll }

    poll.destroy

    opts.each do |opt|
      assert_raise(ActiveRecord::RecordNotFound) { Option.find opt.id }
    end
  end

  test "votes" do
    poll = create :poll

    # 3 options, each with 3 votes
    opts = (1..3).map { create :option, :poll => poll }
    votes = opts.map{ |opt| (1..3).map { create :vote, :option => opt } }.flatten

    assert_equal 9, poll.votes.size
    assert_equal votes.to_set, poll.votes.to_set  
  end

  test "user" do
    user = create :user
    poll = create :poll, :user => user
    assert_equal user, poll.user
  end

  test "nested attributes" do
    # create with nested attributes

    poll = create :poll, :options_attributes => [{:label => 'a'},
                                                 {:label => 'b'},
                                                 {:label => ' '}]

    option_a = poll.options.find_by_label 'a'
    option_b = poll.options.find_by_label 'b'

    assert_equal Set[option_a, option_b], poll.options.to_set

    # update with nested attributes

    poll.update_attributes! :options_attributes => [{:label => 'a', :id => option_a.id},
                                                    {:_destroy => true, :id => option_b.id},
                                                    {:label => 'c'}]

    option_c = poll.options.find_by_label 'c'

    assert_equal Set[option_a, option_c], poll.reload.options.to_set
  end

  test "protected attributes" do
    poll = create :poll, :user_id    => 1000,
                         :closed     => false,
                         :key        => 'abc',
                         :short_link => 'def'

    poll.update_attributes! :user_id    => 2000,
                            :closed     => true,
                            :key        => 'ghi',
                            :short_link => 'jkl'

    poll.reload

    assert_equal poll.user_id,    1000
    assert_equal poll.closed,     false
    assert_equal poll.key,        'abc'
    assert_equal poll.short_link, 'def'
  end

  test "validation" do
    poll = build :poll, :user_id => nil
    assert poll.invalid?

    poll = build :poll, :title => ' '
    assert poll.invalid?

    poll = build :poll, :key => ' '
    assert poll.invalid?
  end

  test "voters" do
    poll1 = create :poll
    poll2 = create :poll
    option_a = create :option, :poll => poll1
    option_b = create :option, :poll => poll1
    user_1 = create :user
    user_2 = create :user
    user_3 = create :user
    option_poll2 = create :option, :poll => poll2

    # user 1: votes for a and b
    # user 2: vote for v
    # user 3: no vote for poll1
    create :vote, :user => user_1, :option => option_a
    create :vote, :user => user_1, :option => option_b

    create :vote, :user => user_2, :option => option_b, :yes => false

    create :vote, :user => user_3, :option => option_poll2

    assert_equal Set[user_1, user_2], poll1.voters.to_set
  end

  test "to_param" do
    poll = create :poll, :key => 'fookey'
    assert_equal 'fookey', poll.to_param
  end

  test "generate_short_link" do
    poll = create :poll
    poll.generate_short_link

    expected_url = "#{MITDOODLE_HOME}/polls/#{poll.key}"
    assert_redirects_to expected_url, poll.short_link
  end
end
