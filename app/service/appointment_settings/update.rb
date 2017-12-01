module AppointmentSettings
  # update appoiontment setting
  class Update
    include Serviceable

    attr_reader :doctor, :params

    validates! :week_day, presence: true
    validate :validate_periods, :validate_weekday

    def initialize(doctor, params)
      @doctor = doctor
      @params = params
      @time_periods = params[:periods]
      id = params[:id]
      @week_day = id.downcase if id.present?
    end

    def call
      valid?
      update_with_transaction
      AppointmentSettings::FetchOne.call(doctor, week_day).result

    rescue ActiveModel::StrictValidationFailed, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed
      errors.add :base, $!.message
    end

    private

    attr_reader :time_periods, :doctor, :week_day

    def update_with_transaction
      transaction do
        delete_extra_periods
        create_new_periods
      end
    end

    def validate_weekday
      doctor_weekdays = Doctor.week_days
      valid_doctor_week_day = doctor_weekdays.include?(week_day.to_sym)

      fail!("#{week_day} is not a valid weekday") unless valid_doctor_week_day

      if week_day == doctor.current_time.strftime("%A").downcase
        fail!("Can not edit plan for today.") unless valid_doctor_week_day
      end
    end

    def validate_periods
      fail!("time_periods should not be nil") if time_periods.blank?
      time_periods.sort_by!{|period| period[:start_time]}
      time_periods.each_with_index do |period, index|
        time_periods_check(period, index)
      end
    end

    def time_periods_check(period, index)
      max_minuts = AppointmentSetting::MIN_DURATION_MIN
      if Update.time_in_minute(period[:start_time]) + max_minuts > Update.time_in_minute(period[:end_time])
        fail!("#{Update.time_range(period)} start time must before end time at least #{max_minuts}")
      end
      next_preiod = time_periods[index + 1]
      UpdateExtDecorator.new(period, next_preiod).validate_mixed_periods if next_preiod.present?
    end

    def get_doctor_settings_periods
      doctor.appointment_settings.where(week_day: week_day).map do |setting|
        {start_time: setting.start_time, end_time: setting.end_time}
      end
    end


    def new_hourly_periods
      Update.separate_setting_params_into_hourly(time_periods)
    end

    def old_hourly_periods
      old_hourly_periods = get_doctor_settings_periods
    end

    def need_add_hourly_periods
      new_hourly_periods - old_hourly_periods
    end

    def need_delete_hourly_periods
      old_hourly_periods - new_hourly_periods
    end

    def delete_extra_periods
      need_delete_hourly_periods.each do |period|
        appointment_setting = doctor.appointment_settings.find_by(period.merge(week_day: week_day))
        appointment_setting.destroy! if appointment_setting.present?
      end
    end

    def create_new_periods
      need_add_hourly_periods.each do |period|
        appointment_setting = doctor.appointment_settings.create!(period.merge(week_day: week_day))
      end
    end

    def self.end_of_day_time_str
      Time.new.end_of_day.strftime("%H:%M")
    end

    def self.next_hour_time time_str
      end_of_day_time_str = self.end_of_day_time_str
      return "24:00" if time_str == end_of_day_time_str
      next_hour = self.set_next_hour(time_str)
      next_hour == 24 ? end_of_day_time_str : self.set_next_hour_str(next_hour)
    end

    def self.set_next_hour time_str
      hour, minute= time_str.split(":")
      hour = hour.to_i + 1
      hour
    end

    def self.set_next_hour_str next_hour
      next_hour_str = next_hour < 10 ? "0#{next_hour}" : next_hour.to_s
      next_hour_str = next_hour_str+":00"
      next_hour_str
    end

    def self.time_range period
      "#{period[:start_time]}-#{period[:end_time]}"
    end

    def self.time_include_in_period(time, period)
      if time < period[:end_time] && time > period[:start_time]
        return true
      end
      return false
    end

    def self.separate_setting_params_into_hourly(time_periods)
      hourly_arr_params = []
      time_periods.each do |setting|
        set_time_with_minute(setting, hourly_arr_params)
      end

      hourly_arr_params
    end

    def self.set_time_with_minute(setting, hourly_arr_params)
      hourly_start_time = setting[:start_time]
      hourly_end_time = self.next_hour_time(hourly_start_time)

      while self.time_in_minute(hourly_end_time) <= self.time_in_minute(setting[:end_time]) do
        hourly_arr_params << {start_time: hourly_start_time, end_time: hourly_end_time}
        hourly_start_time = hourly_end_time
        hourly_end_time = self.next_hour_time(hourly_end_time)
      end
    end

    def self.time_in_minute time_str
      hour, minute = time_str.split(":")
      (hour.to_i*60 + minute.to_i)
    end
  end

  # Decorator the update method
  class UpdateExtDecorator
    include Serviceable

    attr_reader :period, :next_preiod
    def initialize(period, next_preiod)
      @period = period
      @next_preiod = next_preiod
    end

    def validate_mixed_periods
      pre_period = Update.time_range(@period)
      if period == @next_preiod
        fail!("period #{pre_period} are repeated")
      elsif Update.time_include_in_period(period[:start_time], @next_preiod) || Update.time_include_in_period(period[:end_time], @next_preiod) || 
        Update.time_include_in_period(@next_preiod[:start_time], period) || Update.time_include_in_period(@next_preiod[:end_time], period)
        fail!("period #{Update.time_range(@next_preiod)} are mixed with period #{pre_period}")
      end
    end
  end
end
