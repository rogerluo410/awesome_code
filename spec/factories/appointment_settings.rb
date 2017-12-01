FactoryGirl.define do
  factory :appointment_setting do
    start_time { "#{'%02d' % rand(22)}:00"  }
    end_time { "#{'%02d' % ((start_time.split(':')).first.to_i + 1)}:00" }
  end
end
