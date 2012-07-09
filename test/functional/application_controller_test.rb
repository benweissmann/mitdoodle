require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  tests DashboardController

  setup do
  end

  test "require login ENV" do
    get :index
    assert_response :forbidden

    ENV['REMOTE_USER'] = ' '
    get :index
    assert_response :forbidden

    ENV['REMOTE_USER'] = 'bsw'
    get :index
    assert_response :success

    ENV['REMOTE_USER'] = nil
  end

  test "require login request.env" do
    get :index
    assert_response :forbidden

    request.env['REMOTE_USER'] = ' '
    get :index
    assert_response :forbidden

    request.env['REMOTE_USER'] = 'bsw'
    get :index
    assert_response :success

    request.env['REMOTE_USER'] = nil
  end

  test "current_user, new user" do
    request.env['REMOTE_USER'] = 'joe'
    assert_equal 'joe', @controller.current_user.username
    assert_equal User.find_by_username('joe'), @controller.current_user
  end

  test "current user, existing user" do
    user = create :user, :username => 'james'
    request.env['REMOTE_USER'] = 'james'
    assert_equal user, @controller.current_user
  end
end
