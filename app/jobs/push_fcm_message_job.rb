class PushFcmMessageJob < ApplicationJob
  attr_reader :fcm_message

  def perform(fcm_message)
    return unless fcm_message.pending?

    @fcm_message = fcm_message
    fcm_message.processing!

    resp = fcm_service.send(
      fcm_message.tokens,
      notification: fcm_message.notification,
      data: fcm_message.data,
    )
    set_success(resp)
  rescue FcmSendError => err
    set_failure(err)
  end

  private

  def fcm_service
    @fcm_service ||= FcmService.new
  end

  def set_success(resp)
    fcm_message.update!(
      status: resp.success? ? :success : :failure,
      success_count: resp.success_count,
      failure_count: resp.failure_count,
      raw_resp: resp.raw_resp,
    )
  end

  def set_failure(error)
    fcm_message.update!(
      status: :failure,
      ex: error.class.name,
      ex_message: error.message,
    )
  end
end
