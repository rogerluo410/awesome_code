module Api
  module V1
    class AddressSerializer < ::ActiveModel::Serializer

      attributes(
        :id,
        :postcode,
        :state,
        :suburb,
        :street_address
      )
    end
  end
end
