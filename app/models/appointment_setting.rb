class AppointmentSetting < ApplicationRecord
  include ReferenceUpdatable
  include AppointmentProductProcessor
  include AppointmentPeriodProcessor

  belongs_to :doctor, foreign_key: :user_id
  has_many :appointment_products, dependent: :nullify
  validates_format_of :start_time, with: /\d\d:\d\d/, allow_nil: false
  validates_format_of :end_time, with: /\d\d:\d\d/, allow_nil: false

  MIN_DURATION_MIN = 15
  ESTIMATION_INTERVAL_TIME = 12

  scope :with_week_day, ->(week_day) {
    where(week_day: week_day.to_s).order(:start_time)
  }


  def start_time_in_doctor_timezone
    hour, minute = start_time.split(":")
    doctor.current_time.change(hour: hour, min: minute)
  end

  def end_time_in_doctor_timezone
    hour, minute = end_time.split(":")
    doctor.current_time.change(hour: hour, min: minute)
  end

  def available_slots(s_time = nil, e_time = nil)
    fina_start_time = s_time
    fina_end_time = e_time

    if s_time.present? && e_time.present?
      begin
        fina_start_time = Time.parse(s_time) if s_time.is_a?(String)
        fina_end_time = Time.parse(e_time) if e_time.is_a?(String)
      rescue Exception => e
        fina_start_time = nil
        fina_end_time = nil
      end
    end

    if fina_start_time.present? && fina_end_time.present?
      return 0 if e_time <= Time.current
      appointment_product_with_time(fina_start_time, fina_end_time).try(:available_slots) || total_slot_number(fina_start_time, fina_end_time)
   else
      current_appointment_product.try(:available_slots) || total_slot_number(start_time_in_doctor_timezone, end_time_in_doctor_timezone)
   end
  end

  # estimate 15 minutes for each person
  def total_slot_number(s_time, e_time)
    return 0 if doctor.current_time > e_time
    during_seconds = 0
    if doctor.current_time > s_time
      during_seconds = e_time - doctor.current_time
    else
      during_seconds = e_time - s_time
    end

    ((during_seconds / 60) / AppointmentSetting::ESTIMATION_INTERVAL_TIME).to_i
  end

  private
end
