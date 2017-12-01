require 'service/push_data/base_examples'

RSpec.describe PushData::SurveyUpdated do
  include_examples 'push data base examples'

  subject { described_class.(survey) }

  let(:receiver) { create(:doctor, devices: devices) }
  let(:app) { double('Appointment', id: 1, doctor: receiver) }
  let(:push_data) { { 'op' => 'survey_updated', 'survey_id' => survey.id, 'app_id' => app.id } }
  let(:survey) { create(:survey).tap { |s| allow(s).to receive(:appointment).and_return(app) } }

  before do
    allow(DoctorWorkspaceChannel).to receive(:broadcast_survey_updated)
  end

  it 'pushes data via cable' do
    expect(subject).to be_success
    expect(DoctorWorkspaceChannel).to have_received(:broadcast_survey_updated).with(survey)
  end
end
