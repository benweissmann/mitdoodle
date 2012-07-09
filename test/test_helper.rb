ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'set'
require 'mocha'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  def login username='testuser'
    request.env['REMOTE_USER'] = username
  end

  def test_user
    User.find_or_create_by_username 'testuser'
  end

  def assert_redirects_to expected_url, short_link
    response = Net::HTTP.get_response URI(short_link)

    case response
    when Net::HTTPRedirection then
      assert_equal expected_url, response['location']
    else
      assert_equal expected_url, short_link
    end
  end
end
