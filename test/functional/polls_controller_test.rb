require 'test_helper'

class PollsControllerTest < ActionController::TestCase
  setup do
    login
  end

  test "index should redirect to home" do
    get :index
    assert_redirected_to MITDOODLE_HOME
  end


  test "should show poll" do
    poll = create :poll
    opt1 = create :option_with_votes, :poll => poll, :yes_votes => 3, :no_votes => 2
    opt2 = create :option_with_votes, :poll => poll, :yes_votes => 2, :no_votes => 2
    opt3 = create :option_with_votes, :poll => poll, :yes_votes => 3, :no_votes => 4
    opt4 = create :option_with_votes, :poll => poll, :yes_votes => 0, :no_votes => 5

    get :show, :id => poll.to_param
    assert_response :success
    assert_equal [[3, true], [2, false], [3, true], [0, false]], assigns(:counts)
    assert_equal [opt1, opt3], assigns(:most_popular)
    assert_equal poll, assigns(:poll)
    assert_template 'show'
  end

  test "can't access poll via id" do
    poll = create :poll
    get :show, :id => poll.id
    assert_redirected_to MITDOODLE_HOME
    assert_equal 'Invalid poll key', flash[:error]
  end

  test "should get new" do
    get :new
    assert_response :success
    assert assigns(:poll).instance_of? Poll
    assert_equal 4, assigns(:poll).options.size
    assert_template 'new'
  end

  test "should get edit" do
    poll = create :poll, :user => test_user
    get :edit, :id => poll.to_param
    assert_response :success
    assert_equal assigns(:poll), poll
    assert_template 'edit'
  end

  test "edit requires ownership" do
    poll = create :poll
    get :edit, :id => poll.to_param
    assert_forbidden poll
  end

  test "should create poll" do
    assert_difference('Poll.count') do
      post :create, :poll => {:title => 'Foo', :options_attributes => [:label => 'foo']}
    end

    poll = assigns(:poll)
    assert_equal test_user, poll.user
    assert_not_nil poll.key
    assert_redirects_to MITDOODLE_HOME+poll_path(poll), poll.short_link

    assert_redirected_to poll_path(poll)
  end

  test "unsuccessful poll creation" do
    assert_no_difference('Poll.count') do
      post :create, :poll => {:options_attributes => [:label => 'foo']}
    end

    assert_response :success
    assert_template 'new'
    poll = assigns(:poll)
    assert poll.errors.any?
    assert_equal 'foo', poll.options.first.label
    assert_equal 4, poll.options.length
  end

  test "should update poll" do
    poll = create :poll, :user => test_user
    opt = create :option, :poll => poll
    attrs = poll.attributes
    attrs[:title] = 'new title'

    put :update, :id => poll.to_param, :poll => attrs
    assert_redirected_to poll_path(poll)
    assert_equal 'new title', poll.reload.title
  end

  test "update requires ownership" do
    poll = create :poll, :title => 'old title'
    attrs = poll.attributes
    attrs[:title] = 'new title'

    put :update, :id => poll.to_param, :poll => attrs
    assert_forbidden poll
    assert_equal 'old title', poll.reload.title
  end

  test "voting" do
    poll = create :poll
    opt1 = create :option, :poll => poll
    opt2 = create :option, :poll => poll
    opt3 = create :option, :poll => poll

    post :vote, {:id => poll.to_param, opt2.id.to_s => '1'}
    assert_redirected_to poll_path(poll)
    assert_equal 'You have successfully voted.', flash[:notice]

    assert_equal false, Vote.find_by_user_id_and_option_id(test_user, opt1.id).yes
    assert_equal true, Vote.find_by_user_id_and_option_id(test_user, opt2.id).yes
    assert_equal false, Vote.find_by_user_id_and_option_id(test_user, opt3.id).yes
  end 

  test "voting requires poll to be open" do
    poll = create :poll, :closed => true
    opt1 = create :option, :poll => poll
    opt2 = create :option, :poll => poll
    opt3 = create :option, :poll => poll

    post :vote, {:id => poll.to_param, opt1.id.to_s => '1'}
    assert_redirected_to poll_path(poll)
    assert_equal 'The poll is closed', flash[:error]

    assert_nil Vote.find_by_user_id_and_option_id(test_user, opt1.id)
    assert_nil Vote.find_by_user_id_and_option_id(test_user, opt2.id)
    assert_nil Vote.find_by_user_id_and_option_id(test_user, opt3.id)
  end

  test "closing" do
    poll = create :poll, :user => test_user
    post :close, :id => poll.to_param
    assert_redirected_to poll_path(poll)
    assert_equal 'Poll has been closed', flash[:notice]
  end

  test "closing required ownership" do
    poll = create :poll
    post :close, :id => poll.to_param
    assert_forbidden poll
  end

  test "opening" do
    poll = create :poll, :user => test_user
    post :open, :id => poll.to_param
    assert_redirected_to poll_path(poll)
    assert_equal 'Poll has been opened', flash[:notice]
  end

  test "opening required ownership" do
    poll = create :poll
    post :open, :id => poll.to_param
    assert_forbidden poll
  end

  test "delete_voter" do
    poll = create :poll, :user => test_user
    opt1 = create :option, :poll => poll
    opt2 = create :option, :poll => poll
    opt3 = create :option, :poll => poll

    login 'foo'
    foo = create :user, :username => 'foo'
    post :vote, {:id => poll.to_param, opt2.id.to_s => '1'}

    login 'bar'
    bar = create :user, :username => 'bar'
    post :vote, {:id => poll.to_param, opt1.id.to_s => '1'}

    login 'testuser'
    post :delete_voter, :id => poll.to_param, :voter_id => bar.id
    assert_redirected_to poll_path(poll)
    assert_equal 'Vote deleted', flash[:notice]

    assert_equal false, Vote.find_by_user_id_and_option_id(foo.id, opt1.id).yes
    assert_equal true, Vote.find_by_user_id_and_option_id(foo.id, opt2.id).yes
    assert_equal false, Vote.find_by_user_id_and_option_id(foo.id, opt3.id).yes

    assert_nil Vote.find_by_user_id_and_option_id(bar.id, opt1.id)
    assert_nil Vote.find_by_user_id_and_option_id(bar.id, opt2.id)
    assert_nil Vote.find_by_user_id_and_option_id(bar.id, opt3.id)
  end

  test "delete_voter requires ownership" do
    poll = create :poll
    opt1 = create :option, :poll => poll
    opt2 = create :option, :poll => poll
    opt3 = create :option, :poll => poll

    login 'foo'
    foo = create :user, :username => 'foo'
    post :vote, {:id => poll.to_param, opt2.id.to_s => '1'}

    login 'bar'
    bar = create :user, :username => 'bar'
    post :vote, {:id => poll.to_param, opt1.id.to_s => '1'}

    post :delete_voter, :id => poll.to_param, :voter_id => bar.id

    assert_equal false, Vote.find_by_user_id_and_option_id(foo.id, opt1.id).yes
    assert_equal true, Vote.find_by_user_id_and_option_id(foo.id, opt2.id).yes
    assert_equal false, Vote.find_by_user_id_and_option_id(foo.id, opt3.id).yes
  end

  def assert_forbidden poll
    assert_redirected_to poll_url(poll)
    assert_equal "You don't have permission to do that", flash[:error]
  end
end
