class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :resource, polymorphic: true
  after_create_commit :realtime_push_to_client

  scope :cursor_at, ->(next_cursor){
    where('id <= %s' % next_cursor.to_i)
  }

  scope :read, -> { where(is_read: true) }
  scope :unread, -> { where(is_read: false) }

  attr_reader :patient, :doctor, :start_time, :end_time, :available_slots

  def title
    return 'You have received an notify' if resource.blank?

    case n_type.to_s.to_sym
    when :appoint
      'You have received an appointing from %s' % resource.patient.name
    when :appoint_accepted
      'You appointing has accepted by doctor %s' % resource.doctor.name
    when :p_consultation_begin
      'Your appointment is about to begin'
    when :d_consultation_begin
      'Your appointment is about to begin'
    when :comment
      'You have received a comment'
    when :meidcal_certificate
      'You have received a meidcal certificate'
    else
      'You have received an notify'
    end
  end

  def body
    return 'You have received an notify' if resource.blank?

    case resource_type.to_s
    when 'Appointment'
      decorator_appointment
    when 'Comment'
      resource.body
    when 'MeidcalCertificate'
      "You have received a meidcal certificate #{resource.file_identifier}"
    else
      'You have received an notify'
    end
  end


  def set_notification_attr
    case n_type.to_s.to_sym
    when :appoint, :d_consultation_begin
      @patient = resource.patient
      appointemtn_product = resource.appointment_product

      @start_time = appointemtn_product.start_time_in_timezone(@patient.local_timezone)
      @end_time = appointemtn_product.end_time_in_timezone(@patient.local_timezone)
      @available_slots = appointemtn_product.available_slots

    when :appoint_accepted, :p_consultation_begin
      @doctor = resource.doctor
      appointemtn_product = resource.appointment_product

      @start_time = appointemtn_product.start_time_in_timezone(@doctor.local_timezone)
      @end_time = appointemtn_product.end_time_in_timezone(@doctor.local_timezone)
    else
    end
  end

  def decorator_appointment
    set_notification_attr

    case n_type.to_s.to_sym
    when :appoint
      'You have received a request for an appointment from %s on the %s between %s-%s. There are now %s places available in this hour. Please accept or decline this request.' % [@patient.name,
          @start_time.to_s(:normal_date), @start_time.to_s(:hour_ampm), @end_time.to_s(:hour_ampm), @available_slots]
    when :appoint_accepted
      'Your appointment with %s on the %s between %s-%s has been confirmed. There are %s person before you in the queue for this hour. You will be notified when your appointment is about commence.' % [@doctor.name,
          @start_time.to_s(:normal_date), @start_time.to_s(:hour_ampm), @end_time.to_s(:hour_ampm),
          resource.queue_before_me == "not in queue" ? 0 : resource.queue_before_me
        ]
    when :p_consultation_begin
      'Your appointment with %s on the %s between %s-%s is about to begin. Follow this link and wait for your doctor to commence your consultation' % [@doctor.name,
          @start_time.to_s(:normal_date), @start_time.to_s(:hour_ampm), @end_time.to_s(:hour_ampm)]
    when :d_consultation_begin
      'Your appointment with %s on the %s between %s-%s is about to begin. Follow this link and commence the consultation when you are ready.' % [@patient.name,
          @start_time.to_s(:normal_date), @start_time.to_s(:hour_ampm), @end_time.to_s(:hour_ampm)]
    else
      'You have received an normal notify'
    end
  end

  def create_fcm_message
    tokens = user.devices.map(&:token)
    return if tokens.blank?

    set_notification_attr

    FcmMessage.create!(
      receiver: user,
      tokens: tokens,
      notification: {
        title: title,
        body: body,
        badge: user.notifications.unread.count,
      },
      data: {
        n_id: id,
        n_type: n_type,
      },
      web_notification: self,
    )
  end

  private

  def realtime_push_to_client
    return unless user

    NotificationWebJob.perform_now(self)
    if user.notify_system? && user.devices.exists?
      PushFcmMessageJob.perform_later(create_fcm_message)
    end
    NotificationSmsJob.perform_later(self) if user.notify_sms? && user.phone.present?
    # UserMailer.notification_email(self).deliver_later if user.notify_email?
  end
end
