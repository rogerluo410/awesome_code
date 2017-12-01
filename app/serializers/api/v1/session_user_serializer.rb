module Api
  module V1
    class SessionUserSerializer < ActiveModel::Serializer
      attributes :id, :name, :type, :avatar_url, :time_zone

      def time_zone
        object.local_timezone
      end
    end
  end
end
