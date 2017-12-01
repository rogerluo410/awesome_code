class Comment < ApplicationRecord
  belongs_to :appointment
  belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id
  after_create_commit :notify_receiver

  class << self
    def get_list_by_appointment(appointment_id, user)
      for_user_appointment(user, appointment_id)
        .includes(:sender)
    end

    private

    def for_user_appointment(user, appointment_id)
      where(receiver: user, appointment_id: appointment_id)
        .or(where(sender: user, appointment_id: appointment_id))
    end
  end

  def notify_receiver
    CommentChannelJob.perform_later(self)

    Notification.create(user_id: receiver_id,
                    resource_id: id,
                    resource_type: 'Comment',
                    n_type: 'comment',
                )
  end
end
