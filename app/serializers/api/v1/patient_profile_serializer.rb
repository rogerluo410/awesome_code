module Api
  module V1
    class PatientProfileSerializer < ::ActiveModel::Serializer

      attributes(
        :id,
        :sex,
        :birthday
      )

    end
  end
end
