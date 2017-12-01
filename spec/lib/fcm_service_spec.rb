RSpec.describe FcmService do
  include_context "fake FCM"

  it "raises error if ENV['FCM_API_KEY'] not provided" do
    api_key = ENV['FCM_API_KEY']
    ENV['FCM_API_KEY'] = nil
    expect { FcmService.new }.to raise_error(FcmConfigError, "ENV['FCM_API_KEY'] not provided")
    ENV['FCM_API_KEY'] = api_key
  end

  it "wraps the response" do
    stub_fcm_send_success

    tokens = ['aaa', 'bbb']
    opts = { data: { a: 1 } }

    service = FcmService.new
    resp = service.send(tokens, data: { a: 1 })

    expect(resp).to be_success
    expect(resp.success_count).to be 2
    expect(resp.failure_count).to be 1
  end
end
