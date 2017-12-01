module Api
  module V1
    class AppointmentSerializer < ::ActiveModel::Serializer
      attributes(
        :id,
        :status,
        :doctor_id,
        :doctor_name,
        :doctor_email,
        :doctor_specialty_name,
        :doctor_avatar_url,
        :period_start_time,
        :period_end_time,
        :queue_before_me,
        :estimate_consult_time,
        :consultation_fee,
        :paid,
        :survey_id,
        :reason
      )

      delegate :id, :name, :email, :specialty_name, :avatar_url, to: :doctor, prefix: true, allow_nil: true

      def doctor
        object.doctor
      end

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

      def survey_id
        object.survey.try(:id)
      end

      def reason
        object.survey&.reason
      end
    end
  end
end
