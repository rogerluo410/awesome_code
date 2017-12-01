module Api
  module V1
    class PatAppointmentSerializer < ::ActiveModel::Serializer
      type :pat_appointments

      attributes(
        :id,
        :status,
        :doctor_id,
        :doctor_name,
        :doctor_email,
        :doctor_specialty_name,
        :doctor_avatar_url,
        :conference_end_time,
        :prescriptions_status,
        :prescriptions_pharmacy_name
      )

      has_one :medical_certificate, serializer: ::Api::V1::MedicalCertificateSerializer
      has_many :comments, serializer: ::Api::V1::CommentSerializer
      has_many :prescriptions, serializer: ::Api::V1::PrescriptionSerializer

      delegate :id, :name, :email, :specialty_name, :avatar_url, to: :doctor, prefix: true, allow_nil: true

      def doctor
        object.doctor
      end

      def conference_end_time
        object.conferences.last.try(:end_time)
      end

      def prescriptions_status
        object.prescriptions.last.try(:status)
      end

      def prescriptions_pharmacy_name
        object.prescriptions.last.try(:pharmacy_name)
      end
    end
  end
end
