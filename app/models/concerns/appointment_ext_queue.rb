module AppointmentExtQueue
  extend ActiveSupport::Concern

  included do

    def queue_before_me
      return appointment_queue.queue_before_me(id) if in_queue?

      'not in queue'
    end

    def estimate_consult_time
      return 'Time out' if !in_queue?

      if doctor.current_time > appointment_product.start_time
        es_time = (queue_before_me*AppointmentSetting::ESTIMATION_INTERVAL_TIME).minutes.from_now
        es_time.in_time_zone(patient.local_timezone).strftime("%H:%M")
      else
        es_time = appointment_product.start_time + (queue_before_me*AppointmentSetting::ESTIMATION_INTERVAL_TIME).minutes
        es_time.in_time_zone(patient.local_timezone).strftime("%H:%M")
      end
    end

    def is_turn_to_consult?
      return 'It is not time to start.' if doctor.current_time < appointment_product.start_time
      return 'The appointment is time out.' if doctor.current_time >= appointment_product.end_time
      return "You can not start, the appointment is #{status.to_s}." if ["pending", "finished", "decline"].include?(status.to_s)
      return 'This appointment is not in your current schedule.' if appointment_queue.will_pop_element.blank?

      self == Appointment.find_by(id: appointment_queue.will_pop_element)
      return nil
    end

    def appointment_queue
      key = "%s_%s" % [appointment_product_id, appointment_product.start_time]
      AppointmentQueue::Base.new(key)
    end

    def appointment_push_to_queue
      appointment_queue.push(id)
    end

    def appointment_remove_from_queue
      appointment_queue.remove(id)
    end

    def in_queue?
      return false if doctor.current_time >= appointment_product.end_time
      return false unless appointment_queue.in_queue?(id)
      true
    end
  end

  module ClassMethods
  end

  private

end
