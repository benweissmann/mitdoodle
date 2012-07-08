class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_login

  def current_user
    @user ||= login
  end

  private

  def require_login
    if current_username.blank?
      render :text => 'no cert!'
    end
  end

  def login
    User.find_or_create_by_username(current_username)
  end

  def currnet_username
    (request.env['REMOTE_USER'] || ENV['REMOTE_USER'])
  end
end
