class Api::V1::MedicalCertificateSerializer < ActiveModel::Serializer
  attributes :id, :appointment_id, :file_identifier, :file_url

  belongs_to :appointment
end
