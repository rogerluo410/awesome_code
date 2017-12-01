FactoryGirl.define do
  factory :survey do
    appointment nil
    weight 1
    height 1
    occupation "MyString"
    medical_condition "MyText"
    medications "MyText"
    allergies "MyString"
    reason_id 1
  end
end
