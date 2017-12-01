FactoryGirl.define do
  factory :medical_certificate do
    appointment nil
    file File.open("/dev/null")
    deleted false
  end
end
