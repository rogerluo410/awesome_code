module Checkouts
  Schema = Dry::Validation.JSON do
    required(:number).filled(:str?, format?: /\A[0-9]+\z/)
    required(:exp_month) { filled? & int? & gt?(0) & lteq?(12) }
    required(:exp_year).filled(:int?)
    required(:cvc).filled(:str?)
  end
end
