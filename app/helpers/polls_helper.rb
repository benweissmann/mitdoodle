module PollsHelper
  def link_to_add_fields(f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end

    name = capture_haml do
      yield
    end

    link_to_function name,
                     "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")",
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
