module AppointmentProductProcessor
  extend ActiveSupport::Concern

  included do
    def current_appointment_product
      appointment_product_with_time(start_time_in_doctor_timezone, end_time_in_doctor_timezone)
    end

    def appointment_product_with_time(s_time, e_time)
      appointment_products.find_by(start_time: s_time, end_time: e_time)
    end

    def create_or_get_appointment_product(s_time, e_time)
      appointment_product = appointment_product_with_time(s_time, e_time)
      if valid_start_end_time(s_time, e_time) && appointment_product.blank?
        appointment_product = appointment_products.create(start_time: s_time, end_time: e_time, doctor: doctor)
      end
      appointment_product
    end

    def valid_start_end_time(s_time, e_time)
      s_time_in_doctor_timezone = s_time.in_time_zone(doctor.local_timezone)
      e_time_in_doctor_timezone = e_time.in_time_zone(doctor.local_timezone)

      if s_time_in_doctor_timezone.strftime("%A").downcase == week_day && e_time_in_doctor_timezone.strftime("%A").downcase == week_day
        unless s_time_in_doctor_timezone.strftime("%H:%M") == start_time && e_time_in_doctor_timezone.strftime("%H:%M") == end_time
          errors.add(:base, "Start-time and End-time do not match the time in appointment settings")
          return false
        end
      else
        errors.add(:base, "Start-time or End-time do not match the week day of appointment settings")
        return false
      end
      return true
    end
  end
end
