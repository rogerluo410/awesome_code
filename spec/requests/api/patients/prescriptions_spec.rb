RSpec.describe "prescriptions apis" do
  before do
    travel_to "2016-5-24 10:00".in_time_zone('Australia/Sydney')
  end

  let(:sydney) { 'Australia/Sydney' }
  let(:doctor) { create(:doctor, local_timezone: sydney) }
  let(:patient) { FactoryGirl.create(:patient) }
  let(:headers) { token_headers(patient) }

  describe "Put /v1/p/appointments/:appointment_id/prescriptions/deliver" do
    subject {
      put "/v1/p/appointments/#{appointment.id}/prescriptions/deliver",
      params: params,
      headers: headers,
      as: :json
    }

    let!(:appointment_setting) { FactoryGirl.create(:appointment_setting, doctor: doctor, start_time: "07:00", end_time: "13:00", week_day: "tuesday") }
    let!(:appointment_product) { FactoryGirl.create(:appointment_product, doctor: doctor, start_time: Time.parse("2016-5-24 7:00 +10"), end_time: Time.parse("2016-5-24 13:00 +10"), appointment_setting: appointment_setting) }
    let!(:appointment) { FactoryGirl.create(:appointment, patient: patient, doctor: doctor, appointment_product: appointment_product, status: :finished) }
    let!(:prescription) { FactoryGirl.create(:prescription, appointment: appointment) }
    let!(:pharmacy) { FactoryGirl.create(:pharmacy_with_email) }
    let!(:params) { { appointment_id: appointment.id, pharmacy_id: pharmacy.id } }

    context "When patient delivers the prescription to a pharmacy." do
      it "Update the prescription status to delivering and pharmacy_id is what the patient chose." do
        subject
        expect(response).to have_http_status(200)
        expect(response).to match_api_schema(:prescription)
        expect(json['data'].size).to be 1
        expect(json['data'][0]['attributes']['status']).to eql 'delivered'
        expect(json['data'][0]['attributes']['pharmacyId']).to eql pharmacy.id
      end
    end
  end
end
