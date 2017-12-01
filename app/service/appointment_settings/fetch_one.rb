module AppointmentSettings
  # Fetch a appointment setting time with week_time
  class FetchOne
    include Serviceable

    attr_reader :doctor, :week_day

    def initialize(doctor, week_day)
      @doctor = doctor
      @week_day = week_day.to_s
    end

    def call
      arr = []
      appointment_settings = doctor.appointment_settings.with_week_day(week_day)

      DecoractorAppointment.set_appointment_setting_with_week_day(appointment_settings, arr)

      {id: week_day, periods: arr}
    end
  end

  # decorator appointment settings with period
  class DecoractorAppointment
    def self.set_appointment_setting_with_week_day(appointment_settings, arr)
      appointment_settings.each do |period|
        start_time = period.start_time
        end_time = period.end_time
        self.set_arr(start_time, end_time, arr)
      end
    end

    def self.set_arr(start_time, end_time, arr)
      arr_last = arr.last

      if arr_last && arr_last[:end_time] == start_time
        arr[-1][:end_time] = end_time
      else
        arr << {start_time: start_time, end_time: end_time}
      end
    end
  end
end
