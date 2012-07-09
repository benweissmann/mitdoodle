require 'test_helper'

class UrlShortenerTest < ActiveSupport::TestCase
  test "shorten" do
    url = "http://www.example.com/foo"
    shortened = UrlShortener.shorten(url)
    assert_equal 'goo.gl', URI(shortened).host
    assert_redirects_to url, shortened
  end
end
