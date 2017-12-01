FactoryGirl.define do
  factory :doctor_profile do
    specialty { Specialty.all.sample }
    years_experience { rand 10 }
    bio_info { FFaker::Lorem.paragraph }
    approved { true }
    available { [true, false].sample }
    provider_number {  SecureRandom.hex 4 }
  end
end
