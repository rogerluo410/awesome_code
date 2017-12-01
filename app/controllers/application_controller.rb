class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_user_id_cookie, if: :user_signed_in?

  helper_method :current_admin, :current_doctor, :current_patient,
                  :authenticate_admin!, :authenticate_doctor!, :authenticate_patient!

  def after_sign_in_path_for(resource)
    if resource.is_a?(Patient)
      return '/p/dashboard'
    elsif resource.is_a?(Doctor)
      return '/d/workspace'
    elsif resource.is_a?(Admin)
      return admin_doctors_path
    else
      return '/'
    end
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone])
    end

  private

    def current_admin
      @current_admin ||= current_user if user_signed_in? and current_user.class.name == 'Admin'
    end

    def current_doctor
      @current_doctor ||= current_user if user_signed_in? and current_user.class.name == 'Doctor'
    end

    def current_patient
      @current_patient ||= current_user if user_signed_in? and current_user.class.name == 'Patient'
    end

    def admin_logged_in?
      @admin_logged_in ||= user_signed_in? and current_admin
    end

    def doctor_logged_in?
      @doctor_logged_in ||= user_signed_in? and current_doctor
    end

    def patient_logged_in?
      @patient_logged_in ||= user_signed_in? and current_patient
    end

    def authenticate_admin!
      authenticate_user_type(:admin)
    end

    def authenticate_patient!
      authenticate_user_type(:patient)
    end

    def authenticate_doctor!
      authenticate_user_type(:doctor)
    end

    def authenticate_user_type(user_type)
      if (user_type == :admin and !admin_logged_in?)
        redirect_to new_admin_session_url, status: 301, notice: "You must be logged in a#{'n' if user_type == :admin} #{user_type} to access this content"

        return false
      elsif (user_type == :doctor and !doctor_logged_in?) or
          (user_type == :patient and !patient_logged_in?)

        redirect_to new_user_session_url, status: 301, notice: "You must be logged in a#{'n' if user_type == :admin} #{user_type} to access this content"
        return false
      end
    end

    def set_user_id_cookie
      cookies.signed[:user_id] ||= current_user.id
    end
end
