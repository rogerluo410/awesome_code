RSpec.describe DeclineCallChannel do
  let(:cable_server) { double("ActionCable.server") }

  before do
    allow(ActionCable).to receive(:server).and_return(cable_server)
  end

  it '.broadcast_call_declined' do
    app = double('Appointment', id: 1, patient_id: 2, doctor_id: 3)

    expect(cable_server).to(
      receive(:broadcast)
        .with("doctors/#{app.doctor_id}/decline_call_channel", {
          data: {
            appointment_id: app.id,
            patient_id: app.patient_id,
          }
        })
    )

    described_class.broadcast_call_declined(app)
  end
end
