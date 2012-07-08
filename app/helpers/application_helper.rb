module ApplicationHelper
  def format_time time
    time.strftime '%-m/%-d/%y %-H:%M %p'
  end
end
