RSpec.describe Surveys::Update do
  before do
    allow(PushData::SurveyUpdated).to receive(:call)
  end

  it 'pushes data after saving the survey' do
    patient = create(:patient)
    survey = create(:survey, patient: patient)

    # Mock appointment to workaround the callbacks during creation
    allow_any_instance_of(Survey).to(
      receive_message_chain('appointment.status').and_return('pending')
    )

    params = {
      full_name: 'Patient One',
      suburb: FFaker::AddressAU.suburb,
      street_address: FFaker::AddressAU.street_address,
    }

    service = described_class.(patient, survey.id, params)

    expect(service).to be_success
    expect(PushData::SurveyUpdated).to have_received(:call).with(survey)
  end
end
