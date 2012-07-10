require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  setup do
    login
  end

  test "show" do
    get :show, :page => 'credits'
    assert_template 'credits'
    assert_response :success
  end

  test "check page" do
    assert_invalid_page "foo_bar"
    assert_invalid_page "foo/bar"
    assert_invalid_page "credits.haml"
    assert_invalid_page "../foo"
    assert_invalid_page "foo\nbar"
  end

  def assert_invalid_page page
    begin
      get :show, :page => page
    rescue ActionController::RoutingError
      # routing error is an ok outcome
    else
      # make sure we got redirected, not rendered
      assert_redirected_to MITDOODLE_HOME
      assert_equal "Invalid page", flash[:error]
    end
  end
end
