module Api
  module V1
    class BankAccountSerializer < ::ActiveModel::Serializer
      attributes(
        :id,
        :user_id,
        :account_id,
        :country,
        :currency,
        :account_holder_name,
        :account_holder_type,
        :bank_name,
        :last4,
        :routing_number
      )

      def country
        Carmen::Country.coded(object.country).try(:name)
      end
    end
  end
end
