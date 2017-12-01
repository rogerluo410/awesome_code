RSpec.describe PatientDashboardChannel do
  let(:cable_server) { double("ActionCable.server") }

  before do
    allow(ActionCable).to receive(:server).and_return(cable_server)
  end

  it ".dashboard_channel" do
    expect(described_class.dashboard_channel(1)).to eq('p/1/dashboard')
  end

  it ".broadcast_app_accepted" do
    app = double('Appointment', id: 1, patient_id: 2)

    expect(cable_server).to(
      receive(:broadcast)
        .with('p/2/dashboard', { op: 'app_accepted', app_id: '1' })
    )

    described_class.broadcast_app_accepted(app)
  end

  it ".broadcast_app_declined" do
    app = double('Appointment', id: 1, patient_id: 2)

    expect(cable_server).to(
      receive(:broadcast)
        .with('p/2/dashboard', { op: 'app_declined', app_id: '1' })
    )

    described_class.broadcast_app_declined(app)
  end
end
