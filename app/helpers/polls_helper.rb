module PollsHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

  def td_for(user, opt)
    vote = opt.votes.find_by_user_id(user.id)
    if vote.nil?
      haml_tag :td, :class => 'no-vote' do
        yield(nil)
      end
    elsif vote.yes
      haml_tag :td, :class => 'yes' do
        yield(true)
      end
    else
      haml_tag :td, :class => 'no' do
        yield(false)
      end
    end
  end
end
