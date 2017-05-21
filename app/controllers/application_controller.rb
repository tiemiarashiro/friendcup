class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :verify_login

  def verify_login
    redirect_to new_user_session_path unless (user_signed_in? || params[:controller] == "devise/sessions" || params[:controller] == "registrations")
  end
end
