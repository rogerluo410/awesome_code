class FcmMessage < ApplicationRecord
  belongs_to :receiver, class_name: 'User'
  belongs_to :web_notification, class_name: 'Notification'

  enum status: [:pending, :processing, :success, :failure]
end
