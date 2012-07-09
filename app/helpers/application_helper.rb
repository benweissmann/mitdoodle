module ApplicationHelper
  def format_time time
    time.strftime '%-m/%-d/%y %-l:%M %p'
  end
end
