FactoryGirl.define do
  factory :checkout do
    patient { |p| p.association(:patient) }
    stripe_customer_id { SecureRandom.hex }
    brand 'Visa'
    funding 'credit'
    card_last4 { FFaker::String.from_regexp /\d{4}/ }
    exp_month 1
    exp_year 2020
  end
end
