class RemovePhoneNumberFromDoctorProfiles < ActiveRecord::Migration[5.0]
  def change
    remove_column  :doctor_profiles, :phone_number
  end
end
