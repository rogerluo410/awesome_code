module AppointmentSettings
  # get a week time settings
  class FetchAll
    include Serviceable

    attr_reader :doctor

    def initialize(doctor)
      @doctor = doctor
    end

    def call
      Doctor.week_days.map do |weekday|
        AppointmentSettings::FetchOne.call(doctor, weekday).result
      end
    end

    private

    attr_reader :doctor
  end
end
