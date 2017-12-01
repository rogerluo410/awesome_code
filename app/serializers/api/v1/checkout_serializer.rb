module Api
  module V1
    class CheckoutSerializer < ::ActiveModel::Serializer
      attributes(
        :id,
        :card_last4,
        :brand,
        :exp_month,
        :exp_year,
        :funding,
        :default,
      )
    end
  end
end
