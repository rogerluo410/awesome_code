class Doctor::ProfilesController < Doctor::BaseController
  def show
    @doctor = current_doctor
    @doctor.build_address if @doctor.address.blank?
    @doctor.build_doctor_profile if @doctor.doctor_profile.blank?
  end

  def update
    begin
      if current_doctor.update_attributes(doctor_params)
        if current_doctor.unconfirmed_email.present?
          flash[:notice] = "Your email has been changed to #{current_doctor.unconfirmed_email}, and will be updated once you verify this address, please check your email and vifify the address."
        else
          flash[:notice] = "Update successfully"
        end
      else
        flash[:error] = current_doctor.errors.messages
      end
    rescue Excon::Error => ex
      Rails.logger.error ex.response
      flash[:error] = { image: ["failed to update profile because upload picture error"] }
    end

    redirect_to doctor_profile_path
  end

  private

  def doctor_params
    params.require(:doctor).permit(
      :image, :phone, :first_name, :last_name, :email, :username, :notify_email, :notify_system, :notify_sms, :local_timezone,
      doctor_profile_attributes: [
        :id, :years_experience, :bio_info, :provider_number, :specialty_id
      ],
      address_attributes: [
        :id, :country, :postcode, :state, :suburb, :street_address
      ]
    )
  end

end
