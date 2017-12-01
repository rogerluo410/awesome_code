FactoryGirl.define do
  factory :appointment_product do
    start_time "2016-06-22 10:59:55"
    end_time "2016-06-22 10:59:55"

    trait :with_appointment_setting do
      after :create do |ap|
        tz = ap.doctor.try(:local_timezone)
        raise "Must set doctor.local_timezone when using this trait" if tz.blank?

        start_time = ap.start_time.in_time_zone(tz)
        end_time = ap.end_time.in_time_zone(tz)

        setting = FactoryGirl.create(:appointment_setting,
          week_day: start_time.strftime('%A').underscore,
          start_time: start_time.to_s(:time),
          end_time: end_time.to_s(:time),
          doctor: ap.doctor,
        )

        ap.update!(appointment_setting: setting)
      end
    end
  end
end
