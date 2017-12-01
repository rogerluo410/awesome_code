class Patient::ProfilesController < Patient::BaseController
  before_action :build_nested_object, only: [:show]

  def show
    @patient = current_patient
  end

  def update
    begin
      if current_patient.update_attributes(patient_params)
        if current_patient.unconfirmed_email.present?
          flash[:notice] = "Your email has been changed to #{current_patient.unconfirmed_email}, and will be updated once you verify this address, please check your email and vifify the address."
        else
          flash[:notice] = "Update profile successfully"
        end
      else
        flash[:error] = current_patient.errors.messages
      end
    rescue Excon::Error => ex
      Rails.logger.error ex.response
      flash[:error] = { image: ["failed to update profile because upload picture error"] }
    end

    redirect_to patient_profile_path
  end

  private
  def build_nested_object
    current_patient.build_address if current_patient.address.blank?
    current_patient.build_patient_profile if current_patient.patient_profile.blank?
  end

  def patient_params
    params.require(:patient).permit(
      :image, :phone, :first_name, :last_name, :email, :username, :notify_sms,
      :notify_email, :notify_system, :local_timezone,
      patient_profile_attributes: [
        :id, :sex, :birthday
      ],
      address_attributes: [
        :id, :country, :postcode, :state, :suburb, :street_address
      ]
      )
  end
end
