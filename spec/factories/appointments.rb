FactoryGirl.define do
  factory :appointment do
    doctor_id { nil }
    patient_id { nil }
    appointment_product_id { nil }
    status { "pending" }

    trait :with_survey do
      survey do
        FactoryGirl.create(:survey, patient: patient, reason_id: 1)
      end
    end
  end
end
