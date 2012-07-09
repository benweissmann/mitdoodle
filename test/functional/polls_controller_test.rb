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
    template_poll = create :poll
    assert_difference('Poll.count') do
      post :create, :poll => template_poll.attributes
    end

    poll = assigns(:poll)
    assert_equal test_user, poll.user
    assert_not_nil poll.key
    assert_redirects_to MITDOODLE_HOME+poll_path(poll), poll.short_link

    assert_redirected_to poll_path(poll)
  end

  test "should update poll" do
    poll = create :poll, :user => test_user
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

  # TODO:
  # vote
  # close
  # close auth
  # open
  # open auth
  # delete_voter
  # delete_voter auth

  def assert_forbidden poll
    assert_redirected_to poll_url(poll)
    assert_equal "You don't have permission to do that", flash[:error]
  end
end
