require 'service/push_data/base_examples'

RSpec.describe PushData::AppAccepted do
  include_context 'push data base examples'

  subject { described_class.(app) }

  let(:receiver) { create(:patient, devices: devices) }
  let(:app) { double('Appointment', id: 1, patient: receiver) }
  let(:push_data) { { 'op' => 'app_accepted', 'app_id' => app.id } }

  before do
    allow(PatientDashboardChannel).to receive(:broadcast_app_accepted)
  end

  it 'pushes data via cable' do
    expect(subject).to be_success
    expect(PatientDashboardChannel).to have_received(:broadcast_app_accepted).with(app)
  end
end
