module Api
  module V1
    class PharmacySerializer < ::ActiveModel::Serializer
      attributes(
        :id,
        :category,
        :company_name,
        :street,
        :suburb,
        :state,
        :code,
        :email
      )
    end
  end
end
