module Surveys
  class Update
    include Serviceable

    validate :validate_params!

    def initialize(patient, survey_id, params)
      @patient = patient
      @survey_id = survey_id
      @params = params
    end

    def call
      valid?

      survey = patient.surveys.find_by_id(survey_id)
      if survey.blank?
        fail! 'Invalid survey id'
      end

      unless ["pending", "accepted", "processing"].include? survey.appointment.status
        fail! 'This appointment is done'
      end

      survey.update!(params)

      PushData::SurveyUpdated.(survey)

      survey
    end

    private

    attr_reader :patient, :params, :survey_id

    INTEGER_REG = /\A[+-]?\d+\z/

    def validate_params!
      if params[:full_name].blank?
        fail! "Full name must not be blank."
      end

      if params[:suburb].blank?
        fail! "Suburb must not be blank."
      end

      if params[:street_address].blank?
        fail! "Address must not be blank."
      end

      if params[:weight].present?
        fail! 'Weight must be a number' if (params[:weight].to_s !~ INTEGER_REG)
      end

      if params[:height].present?
        fail! 'height must be a number' if (params[:height].to_s !~ INTEGER_REG)
      end

      if params[:age].present?
        fail! 'Age must be a number' if (params[:age].to_s !~ INTEGER_REG)
      end
    end
  end
end
