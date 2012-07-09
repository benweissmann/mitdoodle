require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "format_time" do
    time = Time.new(2012, 7, 8, 20, 40)
    assert_equal "7/8/12 8:40 PM", format_time(time)
  end
end
