class AppointmentProduct < ApplicationRecord
  belongs_to :appointment_setting
  has_many :appointments
  belongs_to :doctor, foreign_key: :doctor_id

  delegate :consultation_fee, :doctor_fee, :application_fee, to: :appointment_setting, allow_nil: true

  class << self
    def get_doctor_scheduled(doctor)
      date = Time.current.in_time_zone(doctor.local_timezone)

      where(doctor: doctor)
        .where("start_time < ? AND end_time > ?", date.end_of_day, date.beginning_of_day)
        .order(:start_time)
    end
  end

  def start_time_in_timezone(timezone)
    start_time.in_time_zone(timezone)
  end

  def end_time_in_timezone(timezone)
    end_time.in_time_zone(timezone)
  end

  def available_slots
    return 0 if end_time <= Time.current
    appointment_setting.total_slot_number(start_time, end_time) - appointments.unfinished.count
  end
end
