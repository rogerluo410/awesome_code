module PushData
  class SurveyUpdated
    include Serviceable
    include Base

    attr_reader :app, :survey

    def initialize(survey)
      @survey = survey
      @app = survey.appointment
      @receiver = app.doctor
    end

    def call
      DoctorWorkspaceChannel.broadcast_survey_updated(survey)
      push_data_via_fcm(op: 'survey_updated', survey_id: survey.id, app_id: app.id)
    end
  end
end
