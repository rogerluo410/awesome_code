FactoryGirl.define do
  factory :authorization do
    user nil
    provider "MyString"
    uid "MyString"
    token "MyString"
    secret "MyString"
  end
end
