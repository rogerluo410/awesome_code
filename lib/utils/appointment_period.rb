class AppointmentPeriod
  attr_accessor :id, :start_time, :end_time, :booked_slots, :remain_slots, :estimation_time, :price

  @booked_slots = 0
  @remain_slots = 0
  @estimation_time = nil
  @price = 0

  def initialize(appointment_setting, appointment_date)
    @id = appointment_setting.id
    @price = appointment_setting.consultation_fee

    init_times(appointment_setting, appointment_date)
    init_slots(appointment_setting)
    init_estimation_time
  end

  def init_times(setting, date)
    start_time_hour, start_time_minute = setting.start_time.split(':')
    end_time_hour, end_time_minute = setting.end_time.split(':')

    @start_time = date.change(hour: start_time_hour.to_i, min: start_time_minute.to_i)
    @end_time = date.change(hour: end_time_hour.to_i, min: end_time_minute.to_i)
  end

  def init_slots(setting)
    total_slots = setting.total_slot_number(start_time, end_time)
    @remain_slots = setting.available_slots(start_time, end_time)
    @remain_slots = 0 if @remain_slots < 0
    @booked_slots = total_slots - @remain_slots
  end

  def init_estimation_time
    if @remain_slots > 0
      @estimation_time = start_time + AppointmentSetting::ESTIMATION_INTERVAL_TIME*booked_slots*60
      @estimation_time = Time.current if @estimation_time < Time.current
    else
      @estimation_time = end_time
    end
  end
end

