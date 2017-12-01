module Api
  module V1
    class DocAppointmentSerializer < ::ActiveModel::Serializer
      type :doc_appointments

      attributes(
        :id,
        :status,
        :period_start_time,
        :period_end_time,
        :consultation_fee,
        :paid,
        :patient_full_name,
        :patient_short_name,
        :conference_end_time,
        :pay_status
      )

      has_one :survey, serializer: ::Api::V1::SurveySerializer
      has_one :medical_certificate, serializer: ::Api::V1::MedicalCertificateSerializer
      has_many :comments, serializer: ::Api::V1::CommentSerializer
      has_many :prescriptions, serializer: ::Api::V1::PrescriptionSerializer

      def period_start_time
        object.appointment_product.start_time
      end

      def period_end_time
        object.appointment_product.end_time
      end

      def consultation_fee
        '%0.2f' % object.consultation_fee.to_f
      end

      def paid
        object.paid?
      end

      def pay_status
        if object.refund_request&.status_refunded?
          'refunded'
        elsif object.paid?
          'paid'
        else
          'unpaid'
        end
      end

      def patient_full_name
        object.patient.try(:full_name)
      end

      def patient_short_name
        object.patient.try(:short_name)
      end

      def conference_end_time
        object.conferences.last.try(:end_time)
      end
    end
  end
end
