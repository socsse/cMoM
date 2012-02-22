class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :store_location

  def store_location
    controller_name = params[:controller]
    session[:user_return_to] = request.url unless controller_name == "devise/registrations" || controller_name == "devise/sessions"
  end

  def after_sign_in_path_for(resource)
    path = stored_location_for(resource) || user_path(current_user)
    Rails.logger.info "Returning path #{path}"
    path
  end

end
