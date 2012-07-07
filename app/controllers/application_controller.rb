class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_login

  def current_user
    @user ||= login
  end

  private

  def require_login
    if ENV['SSL_CLIENT_S_DN_Email'].blank?
      redirect_to MITDOODLE_HOME_BARE + request.path
    end
  end

  def login
    username = ENV['SSL_CLIENT_S_DN_Email'].split('@').first
    User.find_or_create_by_username(username)
  end
end
