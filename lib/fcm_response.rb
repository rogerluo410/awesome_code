class FcmResponse
  attr_reader :raw_resp

  def initialize(raw_resp)
    @raw_resp = raw_resp
  end

  def success?
    status_code.in?(200..299)
  end

  def status_code
    raw_resp[:status_code]
  end

  def body
    @body ||= raw_resp[:body]
  end

  def success_count
    body['success']
  end

  def failure_count
    body['failure']
  end
end
