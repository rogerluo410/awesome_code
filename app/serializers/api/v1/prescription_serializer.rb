module Api
  module V1
    class PrescriptionSerializer < ::ActiveModel::Serializer
      attributes :id, :appointment_id, :pharmacy_id, :file_identifier, :file_url, :status

      belongs_to :appointment
    end
  end
end
