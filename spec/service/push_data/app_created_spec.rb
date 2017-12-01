require 'service/push_data/base_examples'

RSpec.describe PushData::AppCreated do
  include_examples 'push data base examples'

  subject { described_class.(app) }

  let(:receiver) { create(:doctor, devices: devices) }
  let(:app) { double('Appointment', id: 1, doctor: receiver) }
  let(:push_data) { { 'op' => 'app_created', 'app_id' => app.id } }

  before do
    allow(DoctorWorkspaceChannel).to receive(:broadcast_app_created)
  end

  it 'pushes data via cable' do
    expect(subject).to be_success
    expect(DoctorWorkspaceChannel).to have_received(:broadcast_app_created).with(receiver.id)
  end
end
