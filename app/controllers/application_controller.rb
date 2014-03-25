class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :render_404 
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) do |u| 
      u.permit(:profile_name, :email, :password, :first_name, :last_name, :avatar)
    end
    devise_parameter_sanitizer.for(:sign_up) do |u| 
      u.permit(:email, :password, :password_confirmation, 
               :remember_me, :first_name, :last_name, :profile_name, :full_name, :avatar)
    end
    devise_parameter_sanitizer.for(:account_update) do |u| 
      u.permit(:email, :password, :password_confirmation, :current_password,
               :remember_me, :first_name, :last_name, :profile_name, :full_name, :avatar)
    end
  end

  private
  def render_permission_error
    render file: 'public/permission_error', status: :error, layout: false
  end

  def render_404
    render file: 'public/404', status: :not_found
  end
end
