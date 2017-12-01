RSpec.describe DoctorWorkspaceChannel do
  let(:cable_server) { double("ActionCable.server") }

  before do
    allow(ActionCable).to receive(:server).and_return(cable_server)
  end

  it ".broadcast_app_created" do
    expect(cable_server).to(
      receive(:broadcast)
        .with('d/1/workspace', { op: 'app_created' })
    )

    described_class.broadcast_app_created(1)
  end

  it ".broadcast_survey_updated" do
    app = double("Appointment", id: 2, doctor_id: 3)
    survey = double("Survey", id: 1, appointment: app)

    expect(cable_server).to(
      receive(:broadcast)
        .with('d/3/workspace', {
          op: 'survey_updated',
          survey_id: '1',
          app_id: '2',
        })
    )

    described_class.broadcast_survey_updated(survey)
  end

  it ".broadcast_app_paid" do
    app = double("Appointment", id: 1, doctor_id: 2)

    expect(cable_server).to(
      receive(:broadcast)
        .with('d/2/workspace', {
          op: 'app_paid',
          app_id: '1',
        })
    )

    described_class.broadcast_app_paid(app)
  end
end
