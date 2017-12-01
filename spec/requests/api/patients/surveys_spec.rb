RSpec.describe 'Patient survey request', type: :request do
  before do
    travel_to Time.parse("2016-5-24 10:00 +10")
  end

  let(:patient) { create :patient }
  let(:doctor) { FactoryGirl.create(:doctor, local_timezone: 'Australia/Sydney') }
  let(:setting_start_time) {Time.current.change(hour: 8, min: 00)}
  let(:setting_end_time) {Time.current.change(hour: 17, min: 00)}
  let(:appointment_setting) { FactoryGirl.create(:appointment_setting, user_id: doctor.id, start_time: '08:00',
                                end_time: '17:00', week_day: 'tuesday') }
  let(:setting1_product) {create(:appointment_product, appointment_setting: appointment_setting,
                              start_time: setting_start_time, end_time: setting_end_time)}

  let(:appointment) { FactoryGirl.create(:appointment, doctor_id: doctor.id, patient_id: patient.id,
                                          appointment_product: setting1_product) }
  let(:survey) { create :survey, user_id: patient.id, appointment_id: appointment.id }

  describe 'GET /v1/p/surveys/:id' do
    subject { get "/v1/p/surveys/#{survey.id}", headers: token_headers(patient) }

    context 'when match schema' do
      it 'correct' do
        subject

        expect(response).to have_http_status(200)
        expect(response).to match_api_schema(:survey)
      end
    end
  end

  describe 'Put  /v1/p/surveys/:id' do
    let(:params){
      {
        data: {
          full_name: patient.name, suburb: 'abc', age: 18, gender: 'male',
          street_address: 'xxxxx', weight: 70, height: 180, occupation: '123',
          medical_condition: '456', medications: '789', reason_id: 1, allergies: '1'
        }
      }
    }
    subject {
      put "/v1/p/surveys/#{survey.id}",
      headers: token_headers(patient),
      params: params
    }

    context 'When a patient edits the survey.' do
      it 'Edit successfully.' do
        subject

        expect(response).to have_http_status(200)
      end
    end
  end
end
