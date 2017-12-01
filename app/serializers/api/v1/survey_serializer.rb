module Api
  module V1
    class SurveySerializer < ::ActiveModel::Serializer
      attributes(
        :id,
        :full_name,
        :suburb,
        :age,
        :gender,
        :street_address,
        :weight,
        :height,
        :occupation,
        :medical_condition,
        :medications,
        :reason,
        :reason_id,
        :allergies
      )
    end
  end
end
