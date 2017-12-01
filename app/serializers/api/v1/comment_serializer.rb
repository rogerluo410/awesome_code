module Api
  module V1
    class CommentSerializer < ::ActiveModel::Serializer
      attributes(
        :id,
        :sender_id,
        :sender_name,
        :body,
        :created_at,
        :sender_avatar_url
      )

      belongs_to :appointment, serializer: ::Api::V1::PatAppointmentSerializer

      def sender_name
        object.sender.name
      end

      def sender_avatar_url
        object.sender.avatar_url
      end

    end
  end
end
