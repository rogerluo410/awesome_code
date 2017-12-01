FactoryGirl.define do
  factory :charge_event_log do
    stripe_customer_id "MyString"
    amount "9.99"
    currency "MyString"
    card_last4 "MyString"
    card_brand "MyString"
    stripe_charge_id "MyString"
    status 1
    checkout_id 1
    charge_event_id 1
  end
end
