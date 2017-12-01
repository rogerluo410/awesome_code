module Api
  module V1
    class DocProfileSerializer < ::ActiveModel::Serializer
      type :doc_profile

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

      has_one :doctor_profile, serializer: ::Api::V1::DoctorProfileSerializer
      has_one :address, serializer: ::Api::V1::AddressSerializer
    end
  end
end
