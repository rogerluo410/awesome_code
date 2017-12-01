module Api
  module V1
    class PatProfileSerializer < ::ActiveModel::Serializer
      type :pat_profile

      attributes(
        :id,
        :email,
        :first_name,
        :last_name,
        :username,
        :phone,
        :avatar_url,
        :notify_sms,
        :notify_email,
        :notify_system,
        :local_timezone
      )

      has_one :patient_profile, serializer: ::Api::V1::PatientProfileSerializer
      has_one :address, serializer: ::Api::V1::AddressSerializer
    end
  end
end
