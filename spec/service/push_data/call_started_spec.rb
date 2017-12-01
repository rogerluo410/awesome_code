require 'service/push_data/base_examples'

RSpec.describe PushData::CallStarted do
  include_examples 'push data base examples'

  subject { described_class.(app) }

  let(:receiver) { create(:patient, devices: devices) }
  let(:sender) { create(:doctor) }
  let(:app) { double('Appointment', id: 1, patient: receiver, doctor: sender) }
  let(:push_data) { { 'op' => 'call_started', 'app_id' => app.id, 'doctor_id' => app.doctor.id, "n_type" => "call_start" } }

  before do
    allow(CallChannel).to receive(:broadcast_call_started)
  end

  it 'pushes data via cable' do
    expect(subject).to be_success
    expect(CallChannel).to have_received(:broadcast_call_started).with(app)
  end
end
