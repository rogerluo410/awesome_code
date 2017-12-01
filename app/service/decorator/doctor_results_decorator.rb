class Decorator::DoctorResultsDecorator
  include PaginationHelper
  def initialize(search_results, page, from, to)
    @search_results = search_results
    @page = page
    @from = from
    @to = to
  end

  def call
    doctors_ = @search_results.page(@page).per(10).records

    doctors = decorator_doctors(@search_results.results.map{|x| x._source})

    doctors = doctors.sort do |a, b|
      a_start = a.appointment_periods.first.try(:start_time)
      b_start = b.appointment_periods.first.try(:start_time)

      case
      when a_start && b_start then a_start <=> b_start
      when !a_start && b_start then 1
      when a_start && !b_start then -1
      else 0
      end
    end

    { data: doctors, meta: pagination_info(doctors_) }
  end

  private

  def from_time(time_zone)
    @from.in_time_zone(time_zone || 10)
  end

  def to_time(time_zone)
    @to.in_time_zone(time_zone || 10)
  end

  def from_time_weekday(time_zone)
    from_time(time_zone).strftime("%A").downcase
  end

  def to_time_weekday(time_zone)
    to_time(time_zone).strftime("%A").downcase
  end

  def is_available_now?(doctor)
    dynamic_doctor = Doctor.find(doctor.id)

    dynamic_doctor.is_available_now
  end

  def current_time_available_slots(appointment_setting)
    dynamic_appointment_setting = AppointmentSetting.find(appointment_setting.id)

    dynamic_appointment_setting.available_slots(appointment_setting.start_time, appointment_setting.end_time)
  end

  def appointment_setting_time_decorator(time_zone, appointment_setting)
    start_time_hour, start_time_minute = appointment_setting.start_time.split(':')
    end_time_hour, end_time_minute = appointment_setting.end_time.split(':')

    if from_time_weekday(time_zone) == appointment_setting.week_day
      appointment_setting.start_time = from_time(time_zone).change(hour: start_time_hour.to_i, min: start_time_minute.to_i)
      appointment_setting.end_time = from_time(time_zone).change(hour: end_time_hour.to_i, min: end_time_minute.to_i)
    elsif to_time_weekday(time_zone) == appointment_setting.week_day
      appointment_setting.start_time = to_time(time_zone).change(hour: start_time_hour.to_i, min: start_time_minute.to_i)
      appointment_setting.end_time = to_time(time_zone).change(hour: end_time_hour.to_i, min: end_time_minute.to_i)
    end
  end

  def decorator_doctors(doctors)
    doctors.map do |doctor|
      doctor.is_available_now = is_available_now?(doctor)

      appointment_periods = decorator_appointment_settings(doctor.local_timezone, doctor.appointment_settings)
      appointment_periods.sort_by!(&:start_time) if appointment_periods.present?

      doctor.appointment_periods = appointment_periods
      doctor.delete(:approved)
      doctor.delete(:appointment_settings)
      doctor.delete(:local_timezone)
      doctor.delete(:time_zone_to_offset)
      doctor.delete(:updated_at)

      doctor.total_available_slots = doctor.appointment_periods.map { |x| x.available_slots }.inject('+')
      doctor.avatar_url = Doctor.find(doctor.id).try(:avatar_url)
    end

    doctors
  end

  def decorator_appointment_settings(time_zone, appointment_settings)
    appointment_settings_results = []

    appointment_settings.each do |appointment_setting|
      unless (to_time_weekday(time_zone) == appointment_setting.week_day) || (from_time_weekday(time_zone) == appointment_setting.week_day)
        next
      end
      appointment_setting_time_decorator(time_zone, appointment_setting)

      if @from.today?
        appointment_setting.available_slots = current_time_available_slots(appointment_setting)
      else
        appointment_setting.available_slots = 0
      end

      if (appointment_setting.start_time <= to_time(time_zone)) && (appointment_setting.end_time >= from_time(time_zone))
        appointment_settings_results << appointment_setting
      end
    end

    appointment_settings_results
  end

end
