class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_login

  def current_user
    @user ||= login
  end

  private

  def require_login
    if ENV['SSL_CLIENT_S_DN_Email'].blank?
      render :text => 'no cert!'
    end
  end

  def login
    username = (request.env['REMOTE_USER'] || ENV['REMOTE_USER'])
    User.find_or_create_by_username(username)
  end
end
