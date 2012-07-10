require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  test "index" do
    login

    poll1 = create :poll, :user => test_user
    poll2 = create :poll, :user => test_user
    poll3 = create :poll
    poll3_opt = create :option, :poll => poll3
    poll3_vote = create :vote, :option => poll3_opt, :user => test_user
    poll4 = create :poll
    poll4_opt = create :option, :poll => poll4
    poll4_vote = create :vote, :option => poll4_opt, :user => test_user

    get :index
    assert_response :success
    assert_equal [poll2, poll1], assigns(:polls_created)
    assert_equal [poll4, poll3], assigns(:polls_voted)
  end
end
