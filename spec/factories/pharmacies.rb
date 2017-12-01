FactoryGirl.define do
  factory :pharmacy do
    category 'Pharmacies'
    sequence(:company_name) { |n| "Pharmacy #{n}" } 
    sequence(:street) { |n| " origin street #{n}" }
    sequence(:code) { |n| n + Random.rand } 

    factory :pharmacy_with_email do
      email "example@example.com"
    end
  end
end
