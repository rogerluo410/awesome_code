module Api
  module V1
    class DoctorSerializer < ActiveModel::Serializer
      attributes :id, :name, :type, :avatar_url, :time_zone, :specialty_name, :is_available_now,
            :years_experience, :total_patient_count, :created_at, :bio_info

      def time_zone
        object.local_timezone
      end
    end
  end
end
