module AppointmentPeriods
  # search for apoointment period
  class AppointmentPeriodConverter
    attr_reader :settings, :period
    def initialize(settings, period)
      @settings = settings
      @period = period
    end

    def periods
      settings.where("start_time >= ? AND end_time <= ?", @period[:start_time], @period[:end_time])
        .order(:start_time)
        .map { |setting| AppointmentPeriod.new(setting, @period[:date])}
    end
  end

end
