FactoryGirl.define do
  factory :refund_request do
    appointment nil
    status 1
    charge_event_log nil
  end
end
