module AppointmentPeriods
  # The BuildDailyPeriods is responsible for
  # build AppointmentPeriods to search and book
  class BuildDailyPeriods
    include Serviceable

    validates! :date, :timezone, presence: true
    validate :validate_doctor

    def initialize(params)
      @doctor_id = params[:id]
      @timezone = params[:timezone]
      @date = params[:date]
    end

    def call
      valid?
      build_appointment_periods
    end

    protected

    attr_reader :date, :timezone, :doctor, :doctor_id
    delegate :local_timezone, to: :doctor

    def validate_doctor
      @doctor = Doctor.find_by_id(@doctor_id)
      fail! "Doctor id can not be blank." if @doctor_id.blank?
      fail! "Can not find doctor with id #{@doctor_id}" if @doctor.blank?
    end

    def datetime
      TimeConverter.dateStringToDateTime(@date, @timezone)
    end

    def from
      datetime.in_time_zone(local_timezone)
    end

    def to
      offset = @timezone != local_timezone ? 1.minute : 0.second
      datetime.end_of_day.in_time_zone(local_timezone) + offset
    end

    def build_appointment_periods
      periods = []
      build_time_sections_for_doctor.each do |time_period|
        appointment_settings = @doctor.get_appointment_settings_by_week_day(time_period[:week_day])
        periods += AppointmentPeriodConverter.new(appointment_settings, time_period).periods
      end
      periods.compact
    end

    def build_time_sections_for_doctor
      from_weekday = from.strftime('%A').downcase
      to_weekday = to.strftime('%A').downcase

      if from_weekday == to_weekday
        [
          {start_time: '00:00', end_time: '23:59', week_day: from_weekday, date: from},
        ]
      else
        [
          {start_time: from.strftime('%H:%M').downcase, end_time: '23:59', week_day: from_weekday, date: from},
          {start_time: '00:00', end_time: to.strftime('%H:%M').downcase, week_day: to_weekday, date: to}
        ]
      end
    end
  end
end
