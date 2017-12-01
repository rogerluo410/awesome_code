FactoryGirl.define do
  factory :bank_account do
    doctor {|p| p.association(:doctor)}
    account_id 'acct_18GlITDWCTIlkPNg'
  end
end
