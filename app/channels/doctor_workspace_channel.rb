class DoctorWorkspaceChannel < ApplicationCable::Channel
  class << self
    def workspace_channel(doctor_id)
      "d/#{doctor_id}/workspace"
    end

    def broadcast_app_created(doctor_id)
      broadcast(doctor_id, op: 'app_created')
    end

    def broadcast_survey_updated(survey)
      # The resource id must be string because Redux stores ids as string (JSON API standard)
      broadcast(survey.appointment.doctor_id,
        op: 'survey_updated',
        survey_id: survey.id.to_s,
        app_id: survey.appointment.id.to_s,
      )
    end

    def broadcast_app_paid(app)
      broadcast(app.doctor_id, op: 'app_paid', app_id: app.id.to_s)
    end

    private

    def broadcast(doctor_id, json)
      ActionCable.server.broadcast(workspace_channel(doctor_id), json)
    end
  end

  def subscribed
    stop_all_streams
    stream_from self.class.workspace_channel(current_user_id)
  end

  def unsubscribed
    stop_all_streams
  end
end
