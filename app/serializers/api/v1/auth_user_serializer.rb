module Api
  module V1
    class AuthUserSerializer < ActiveModel::Serializer
      attributes :id, :name, :type, :avatar_url, :auth_token, :time_zone, :badge

      def auth_token
        instance_options[:auth_token]
      end

      def time_zone
        object.local_timezone
      end

      def badge
        object.notifications.unread.count
      end
    end
  end
end
