FactoryGirl.define do
  factory :notification do
    n_type { 'p_consultation_begin' }
    is_read { false }
    body { FFaker::Lorem.word }
  end
end
