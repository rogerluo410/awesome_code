module Api
  module V1
    class DoctorProfileSerializer < ::ActiveModel::Serializer

      attributes(
        :id,
        :years_experience,
        :bio_info,
        :specialty_name,
        :specialty_id
      )

      def specialty_id
        object.specialty&.id
      end
    end
  end
end
