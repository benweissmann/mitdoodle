module PollsHelper
  def link_to_add_options(f)
    new_option = Option.new
    fields = f.fields_for(:options, new_option, :child_index => "new_option") do |builder|
      render('option_fields', :f => builder)
    end

    name = capture_haml do
      yield
    end

    link_to_function name,
                     "add_fields(this, \"options\", \"#{escape_javascript(fields)}\")",
                     :class => 'btn btn-success btn-add-option'
  end

  def td_for(user, opt, cls='')
    vote = opt.votes.find_by_user_id(user.id)
    if vote.nil?
      haml_tag :td, :class => "#{cls} no-vote" do
        yield(nil)
      end
    elsif vote.yes
      haml_tag :td, :class => "#{cls} yes" do
        yield(true)
      end
    else
      haml_tag :td, :class => "#{cls} no" do
        yield(false)
      end
    end
  end

  def owner
    controller.current_user == @poll.user
  end
end
