FactoryGirl.define do
  factory :transfer_event_log do
    stripe_transfer_id "tr_123"
    transfer_event_id 1
    currency "aud"
    amount "9.99"
    status 1
    destination "acct_123"
  end
end
