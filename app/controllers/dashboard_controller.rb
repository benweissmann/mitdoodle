class DashboardController < ApplicationController
  def index
    @polls_voted = current_user.polls_voted_in.order('id DESC').all
    @polls_created = current_user.polls.order('id DESC').all
  end
end
