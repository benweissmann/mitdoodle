class StaticController < ApplicationController
  before_filter :check_page
  def show
    respond_to do |format|
      format.html {render params[:page]}
    end
  end

  # Ensure the page parameter doesn't have anything that
  # could cause #show to render something outside of
  # app/views/static. Only allow a-z.
  def check_page
    unless params[:page] =~ /\A[a-z]+\z/
      redirect_to MITDOODLE_HOME
    end
  end
end
