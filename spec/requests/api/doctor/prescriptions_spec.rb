RSpec.describe "prescriptions apis" do
  before do
    travel_to "2016-5-24 10:00".in_time_zone('Australia/Sydney')
  end

  let(:sydney) { 'Australia/Sydney' }
  let(:doctor) { create(:doctor, local_timezone: sydney) }

  let(:headers) { token_headers(doctor) }

  describe "post /v1/d/appointments/:appointment_id/prescriptions" do
    subject {
      post "/v1/d/appointments/#{appointment.id}/prescriptions",
      params: params,
      headers: headers
    }

    let!(:patient) { FactoryGirl.create(:patient) }

    let(:appointment_setting) { FactoryGirl.create(:appointment_setting, doctor: doctor, start_time: "07:00", end_time: "13:00", week_day: "tuesday") }
    let(:appointment_product) { FactoryGirl.create(:appointment_product, doctor: doctor, start_time: Time.parse("2016-5-24 7:00 +10"), end_time: Time.parse("2016-5-24 13:00 +10"), appointment_setting: appointment_setting) }
    let(:appointment) { FactoryGirl.create(:appointment, patient: patient, doctor: doctor, appointment_product: appointment_product, status: :finished) }
    let!(:params) { { appointment_id: appointment.id, file: Rack::Test::UploadedFile.new("#{Rails.root}/spec/requests/api/doctor/upload_test.txt") } }

    context "When a doctor uploads a prescription file." do
      it "gets prescription info including its file URL." do
        subject
        expect(response).to have_http_status(201)
        expect(response).to match_api_schema(:prescription)
        expect(json['data'].size).to be 4
      end
    end
  end
end
