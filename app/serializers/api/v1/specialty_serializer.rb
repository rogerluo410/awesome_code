module Api
  module V1
    class SpecialtySerializer < ActiveModel::Serializer
      attributes(
        :id,
        :name
        )
    end
  end
end
