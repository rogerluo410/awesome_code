FactoryGirl.define do
  factory :prescription do
    appointment nil
    file File.open("/dev/null")
    deleted false
  end
end
