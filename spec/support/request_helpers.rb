module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end

    def expect_422_resp(response, message)
      expect(response).to have_http_status(422)
      expect(json['error']['message']).to eq(message)
    end
  end
end
