module AppointmentExtNotify
  extend ActiveSupport::Concern

  def notify_patient
    AppointmentStatusJob.perform_now(self, self.patient)

    case status.to_s.to_sym
    when :accepted
      notify(patient.id, :appoint_accepted)
    else
    end
  end


  def notify_doctor
    # Wait Open
    # AppointmentStatusJob.perform_later(self, self.doctor)
    case status.to_s.to_sym
    when :pending
      notify(doctor.id, :appoint)
    else
    end
  end

  def notity_next_patient
    if appointment_queue.will_pop_element.present?
      appointment = Appointment.find(appointment_queue.will_pop_element)

      notify(appointment.patient_id, :p_consultation_begin)
      notify(appointment.doctor_id, :d_consultation_begin)
    end
  end

  def notify(user_id, n_type)
    Notification.create!(
      user_id: user_id,
      resource: self,
      n_type: n_type,
    )
  end
end
