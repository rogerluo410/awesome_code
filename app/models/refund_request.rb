class RefundRequest < ApplicationRecord
  extend Enumerize

  belongs_to :appointment
  belongs_to :charge_event_log
  belongs_to :transfer_event_log

  default_scope { order(updated_at: :desc) }

  STATUS_HASH = {
    pending: 1, approved: 2, rejected: 3, refunded: 4
  }

  enumerize :status, in: STATUS_HASH,
            scope: true,
            default: :pending,
            predicates: {prefix: true}


  def get_appointment_brief
    "Doctor <em>#{appointment&.doctor&.name}</em> : Patient <em>#{appointment&.patient&.name}</em>  
     between <em>#{get_appointment_start_time}</em> and <em>#{get_appointment_end_time}</em>     
    "
  end

  def get_appointment_start_time
    appointment&.appointment_product&.start_time
  end

  def get_appointment_end_time
    appointment&.appointment_product&.end_time
  end
end
