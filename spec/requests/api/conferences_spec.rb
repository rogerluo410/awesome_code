RSpec.describe 'Conferences API' do
  let(:doctor) { create(:doctor) }
  let(:patient) { create(:patient) }

  let(:appointment_setting) { create(:appointment_setting, doctor: doctor, start_time: "07:00", end_time: "08:00", week_day: "tuesday") }
  let(:appointment_product) { create(:appointment_product, doctor: doctor, start_time: Time.parse("2016-5-24 7:00 +10"), end_time: Time.parse("2016-5-24 8:00 +10"), appointment_setting: appointment_setting) }
  let(:appointment) { create(:appointment, patient: patient, doctor: doctor, appointment_product: appointment_product) }
  let(:conference) { create(:conference, appointment: appointment) }
  let(:mock_response) { double }
  let(:mock_error) { 'Mock validation error.' }

  describe 'POST /v1/conferences/token' do
    context 'with valid params' do
      it 'returns 200 when getting twilio token for doctor' do
        post '/v1/conferences/token', headers: token_headers(doctor)

        expect(response).to have_http_status(200)
        expect(response).to match_api_schema(:conference_token)
      end

      it 'return 200 when getting twilio token for patient' do
        post '/v1/conferences/token', headers: token_headers(patient)

        expect(response).to have_http_status(200)
        expect(response).to match_api_schema(:conference_token)
      end
    end

    context 'with invalid params' do
      it 'returns 401 getting twilio token for unauthenticated user' do
        post '/v1/conferences/token'

        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /v1/conferences' do
    context 'with valid params' do
      before do
        travel_to Time.parse('2016-5-24 07:30 +10')

        allow(Conferences::Create).to receive(:call).and_return mock_response
        allow(mock_response).to receive(:success?).and_return true
        allow(mock_response).to receive(:conference).and_return conference
        allow(mock_response).to receive(:appointment).and_return appointment
      end

      it 'returns 200 when creating conference for authenticated doctor' do
        post '/v1/conferences', params: {appointment_id: appointment.id}, headers: token_headers(doctor)

        expect(response).to have_http_status(200)
        expect(response).to match_api_schema(:conference)
      end
    end

    context 'with invalid params' do
      before do
        travel_to Time.parse('2016-5-24 07:30 +10')

        allow(Conferences::Create).to receive(:call).and_return mock_response
        allow(mock_response).to receive(:success?).and_return false
        allow(mock_response).to receive(:error).and_return mock_error
      end

      it 'returns 401 when current user is unauthenticated doctor' do
        post '/v1/conferences', params: {appointment_id: appointment.id}, headers: token_headers(patient)
        expect(response).to have_http_status(401)
      end

      it 'returns 422 with invalid params' do
        post '/v1/conferences', params: {appointment_id: appointment.id}, headers: token_headers(doctor)
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq(mock_error)
      end
    end
  end

  describe 'PATCH /v1/conferences/:id' do
    let(:params) { {data: {update_type: 'status', status: 'cancelled_by_doctor'}} }
    context 'with valid params' do
      before do
        travel_to Time.parse('2016-5-24 07:30 +10')

        allow(Conferences::Update).to receive(:call).and_return mock_response
        allow(mock_response).to receive(:success?).and_return true
      end

      it 'returns 200 when creating conference for authenticated doctor' do
        patch "/v1/conferences/#{conference.id}", params: params, headers: token_headers(doctor)

        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid params' do
      before do
        travel_to Time.parse('2016-5-24 07:30 +10')

        allow(Conferences::Update).to receive(:call).and_return mock_response
        allow(mock_response).to receive(:success?).and_return false
        allow(mock_response).to receive(:error).and_return mock_error
      end

      it 'returns 401 current user is unauthenticated doctor' do
        patch "/v1/conferences/#{conference.id}", params: params, headers: token_headers(patient)
        expect(response).to have_http_status(401)
      end

      it 'returns 422 with invalid update params' do
        patch "/v1/conferences/#{conference.id}", params: params, headers: token_headers(doctor)
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq(mock_error)
      end
    end
  end

  describe 'POST /v1/conferences/notify' do
    let(:params) { {data: {appointment_id: appointment.id}} }
    context 'with valid params' do
      before do
        travel_to Time.parse('2016-5-24 07:30 +10')

        allow(Conferences::Notify).to receive(:call).and_return mock_response
        allow(mock_response).to receive(:success?).and_return true
      end

      it 'returns 200 when notify successfully' do
        post '/v1/conferences/notify', params: params, headers: token_headers(doctor)

        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid params' do
      before do
        travel_to Time.parse('2016-5-24 07:30 +10')

        allow(Conferences::Notify).to receive(:call).and_return mock_response
        allow(mock_response).to receive(:success?).and_return false
        allow(mock_response).to receive(:error).and_return mock_error
      end

      it 'returns 401 when current user is unauthenticated doctor' do
        post '/v1/conferences/notify', params: params, headers: token_headers(patient)

        expect(response).to have_http_status(401)
      end

      it 'returns 422 with invalid appointment' do
        post '/v1/conferences/notify', params: params, headers: token_headers(doctor)

        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq(mock_error)
      end
    end
  end

  describe 'POST /v1/conferences/decline_call/:appointment_id' do
    context 'with valid params' do
      before do
        travel_to Time.parse('2016-5-24 07:30 +10')

        allow(Conferences::DeclineCall).to receive(:call).and_return mock_response
        allow(mock_response).to receive(:success?).and_return true
      end

      it 'returns 200 when decline video call successfully' do
        post "/v1/conferences/decline_call/#{appointment.id}", headers: token_headers(patient)

        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid params' do
      before do
        travel_to Time.parse('2016-5-24 07:30 +10')

        allow(Conferences::DeclineCall).to receive(:call).and_return mock_response
        allow(mock_response).to receive(:success?).and_return false
        allow(mock_response).to receive(:error).and_return mock_error
      end

      it 'returns 401 when creating conference for unauthenticated user' do
        post "/v1/conferences/decline_call/#{appointment.id}"

        expect(response).to have_http_status(401)
      end

      it 'returns 422 with invalid appointment' do
        post "/v1/conferences/decline_call/#{appointment.id}", headers: token_headers(patient)

        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq(mock_error)
      end
    end
  end

  describe 'GET /v1/conferences/can_start_call/:appointment_id' do
    context 'with valid params' do
      before do
        travel_to Time.parse('2016-5-24 07:30 +10')

        allow(Conferences::Validation).to receive(:call).and_return mock_response
        allow(mock_response).to receive(:success?).and_return true
      end

      it 'returns 200 when decline video call successfully' do
        get "/v1/conferences/can_start_call/#{appointment.id}", headers: token_headers(patient)

        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid params' do
      before do
        travel_to Time.parse('2016-5-24 07:30 +10')

        allow(Conferences::Validation).to receive(:call).and_return mock_response
        allow(mock_response).to receive(:success?).and_return false
        allow(mock_response).to receive(:error).and_return mock_error
      end

      it 'returns 401 when creating conference for unauthenticated user' do
        get "/v1/conferences/can_start_call/#{appointment.id}"

        expect(response).to have_http_status(401)
      end

      it 'returns 422 with invalid appointment' do
        get "/v1/conferences/can_start_call/#{appointment.id}", headers: token_headers(patient)

        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq(mock_error)
      end
    end
  end
end
