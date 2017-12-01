require 'service/push_data/base_examples'

RSpec.describe PushData::CallDeclined do
  include_examples 'push data base examples'

  subject { described_class.(app) }

  let(:receiver) { create(:doctor, devices: devices) }
  let(:app) { double('Appointment', id: 1, doctor: receiver) }
  let(:push_data) { { 'op' => 'call_declined', 'app_id' => app.id } }

  before do
    allow(DeclineCallChannel).to receive(:broadcast_call_declined)
  end

  it 'pushes data via cable' do
    expect(subject).to be_success
    expect(DeclineCallChannel).to have_received(:broadcast_call_declined).with(app)
  end
end
