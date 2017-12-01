RSpec.describe Comments, type: :request do
  before do
    travel_to "2016-5-24 10:00".in_time_zone('Australia/Sydney')
  end

  let(:patient) {create(:patient)}
  let(:patient1) {create(:patient )}
  let(:doctor) {create(:doctor)}
  let(:appointment_setting) { create(:appointment_setting, doctor: doctor, start_time: "07:00", end_time: "13:00", week_day: "tuesday") }
  let(:appointment_product) { create(:appointment_product, doctor: doctor, start_time: Time.parse("2016-5-24 7:00 +10"), end_time: Time.parse("2016-5-24 13:00 +10"), appointment_setting: appointment_setting) }
  let(:appointment) { create(:appointment, patient: patient, doctor: doctor, appointment_product: appointment_product, status: :finished) }

  let(:comment) { create(:comment, appointment: appointment, receiver: patient, sender: doctor, body: 'hi') }
  let(:comment1) { create(:comment, appointment: appointment, receiver: doctor, sender: patient, body: 'hi') }

  describe 'get /v1/comments' do
    subject { get '/v1/comments', headers: token_headers(patient), params: { appointment_id: appointment.id } }

    context 'correct response with no data' do
      it 'should return 0' do
        subject

        expect(response).to have_http_status(200)
        expect(json['data'].count).to eq(0)
      end
    end

    context 'correct response with no data' do
      it 'should return nil' do
        comment
        subject

        expect(response).to have_http_status(200)
        expect(json['data'].count).to eq(1)
      end
    end
  end
end
