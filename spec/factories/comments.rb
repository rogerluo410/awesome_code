FactoryGirl.define do
  factory :comment do
    appointment nil
    receiver_id 1
    sender_id 1
    body "MyText"
  end
end
