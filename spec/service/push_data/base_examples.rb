RSpec.shared_examples 'push data base examples' do
  include ActiveJob::TestHelper

  let(:devices) { [create(:device, token: 'token_1'), create(:device, token: 'token_2')] }
  let(:device_tokens) { devices.map(&:token) }

  before do
    clear_enqueued_jobs
  end

  it 'pushes data via fcm' do
    expect { subject }.to change(FcmMessage, :count).from(0).to(1)

    expect(subject).to be_success

    fcm_message = FcmMessage.last
    expect(fcm_message.receiver).to eq(receiver)
    expect(fcm_message.tokens).to eq(device_tokens)
    expect(fcm_message.data).to eq(push_data)

    expect(PushFcmMessageJob).to have_been_enqueued.with(fcm_message)
  end
end
