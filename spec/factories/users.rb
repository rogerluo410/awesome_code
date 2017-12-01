FactoryGirl.define do
  sequence :doctor_email do |n|
    "doctor%s@example.com" % n
  end

  sequence :patient_email do |n|
    "patient%s@example.com" % n
  end

  factory :user do
    email { FFaker::Internet.email }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    password { 'password' }
    phone { "+8618621717893" }
    confirmed_at { Time.zone.now }
    local_timezone { UtilsTimeZone.all.map { |zone| zone[:identifier] }.sample }

    factory :admin, class: Admin do
      type { 'Admin' }
    end

    factory :doctor, class: Doctor do
      email { generate :doctor_email }
      type { 'Doctor' }

      trait :with_bank_account do
        bank_account do
          b = FactoryGirl.build(:bank_account)
          b.save!(validate: false)
          b
        end
      end
    end

    factory :patient, class: Patient do
      email { generate :patient_email }
      type { 'Patient' }

      trait :with_checkout do
        after :create do |patient|
          checkout = FactoryGirl.build(:checkout, patient: patient)
          checkout.save!(validate: false)
        end
      end
    end
  end
end
