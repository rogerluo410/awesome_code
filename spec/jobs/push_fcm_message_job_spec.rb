RSpec.describe PushFcmMessageJob do
  include_context "fake FCM"

  let(:fcm_message) do
    FcmMessage.create(
      status: :pending,
      tokens: ['aaa', 'bbb'],
      data: { a: 1 },
    )
  end

  let(:fcm_message_raw_resp) do
    fcm_raw_resp
      .merge(body: JSON.parse(fcm_raw_resp[:body]))
      .stringify_keys
  end

  it "calls FCM success" do
    stub_fcm_send_success

    described_class.perform_now(fcm_message)

    fcm_message.reload
    expect(fcm_message).to be_success
    expect(fcm_message.tokens).to eq ['aaa', 'bbb']
    expect(fcm_message.data).to eq('a' => 1)
    expect(fcm_message.raw_resp).to eq(fcm_message_raw_resp)
    expect(fcm_message.success_count).to be 2
    expect(fcm_message.failure_count).to be 1
  end

  it "calls FCM failure" do
    stub_fcm_send_failure(Net::OpenTimeout, "request timeout")

    described_class.perform_now(fcm_message)

    fcm_message.reload
    expect(fcm_message).to be_failure
    expect(fcm_message.tokens).to eq ['aaa', 'bbb']
    expect(fcm_message.data).to eq('a' => 1)
    expect(fcm_message.raw_resp).to be_nil
    expect(fcm_message.ex).to eq('FcmSendError')
    expect(fcm_message.ex_message).to eq('Net::OpenTimeout: request timeout')
    expect(fcm_message.success_count).to be 0
    expect(fcm_message.failure_count).to be 0
  end

  it "ignores non pending fcm message" do
    fcm_message.processing!

    described_class.perform_now(fcm_message)
    fcm_message.reload

    expect(fcm_message).to be_processing
  end
end
