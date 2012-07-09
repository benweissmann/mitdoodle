class DashboardController < ApplicationController
  def index
    @polls_voted = current_user.polls_voted_in.order('created_at DESC').all
    @polls_created = current_user.polls.order('created_at DESC').all
  end
end
