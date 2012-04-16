class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :do_authentication

  def do_authentication
    authenticate_user!
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || user_path(current_user)
  end

end
