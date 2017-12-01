RSpec.describe CallChannel do
  let(:cable_server) { double("ActionCable.server") }

  before do
    allow(ActionCable).to receive(:server).and_return(cable_server)
  end

  it '.broadcast_call_started' do
    doctor = create(:doctor,
      first_name: 'Doctor',
      last_name: 'One',
      local_timezone: 'Australia/Darwin',
    )
    allow(doctor).to receive(:avatar_url).and_return('fake_avatar_url')

    app = double('Appointment', id: 1, patient_id: 2, doctor: doctor)

    expect(cable_server).to(
      receive(:broadcast)
        .with("patients/#{app.patient_id}/call_channel", {
          data: {
            appointment_id: app.id,
            doctor: {
              id: doctor.id,
              name: doctor.name,
              type: 'Doctor',
              avatar_url: 'fake_avatar_url',
              time_zone: 'Australia/Darwin',
            }
          }
        })
    )

    described_class.broadcast_call_started(app)
  end
end
