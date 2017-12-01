module AppointmentPeriodProcessor
  extend ActiveSupport::Concern

  included do
    TIME_PERIODS = [
      {start_time: "00:00", end_time: "07:00", price: 99, application_fee: 40},
      {start_time: "07:00", end_time: "17:00", price: 37.5, application_fee: 17.5},
      {start_time: "17:00", end_time: "23:59", price: 49.95, application_fee: 20.95},
    ]

    def time_period
      TIME_PERIODS.each do |period|
        if start_time >= period[:start_time] && end_time <= period[:end_time]
          return period
        end
      end
    end

    def consultation_fee
      time_period[:price]
    end

    def application_fee
      time_period[:application_fee]
    end

    def doctor_fee
      (consultation_fee - application_fee).round(2)
    end
  end
end
