RSpec.describe "Appointment settings API" do

  let(:doctor) { create(:doctor) }

  let(:appointment_setting1) {create(:appointment_setting, start_time: "08:00", end_time: "09:00", week_day: "monday", doctor: doctor)}
  let(:appointment_setting2) {create(:appointment_setting, start_time: "07:00", end_time: "08:00", week_day: "monday", doctor: doctor)}

  let(:headers) { token_headers(doctor) }

  describe "get /v1/d/appointment_settings" do
    subject {get '/v1/d/appointment_settings', headers: headers}

    context 'when there is no appointment settings' do
      it 'should be success' do
        subject

        expect(response).to have_http_status(200)
        expect(json['data'].count).to eq(7)
        expect(json['data'][0]["periods"]).to eq([])
      end
    end

    context 'when exist multiple appointment settings' do
      it 'should match the datas' do
        appointment_setting1
        appointment_setting2
        subject
        expect(response).to have_http_status(200)
        expect(json['data'].count).to eq(7)
        expect(json['data'][0]["periods"]).to eq([{"start_time"=>"07:00", "end_time"=>"09:00"}])
      end
    end
  end

  describe 'patch /v1/d/appointment_settings/update_settings' do
    subject {patch '/v1/d/appointment_settings/update_settings', headers: headers, params: params}
    let(:params) {
      {
        data: {
          id: 'monday',
          periods: [
            {start_time: "08:45", end_time: "11:00"},
            {start_time: "11:00", end_time: "12:00"},
            {start_time: "21:45", end_time: "23:59"},
          ]
        }
      }
    }

    context 'when there is no appointment settings' do
      it 'should update success' do
        subject
        expect(response).to have_http_status(200)
        expect(json['data']['id']).to eq('monday')
        expect(json['data']['periods']).to eq([{"start_time"=>"08:45", "end_time"=>"12:00"}, {"start_time"=>"21:45", "end_time"=>"23:59"}])
      end
    end

    context 'when exist appointment settings' do
      it 'should update success' do
        appointment_setting1
        appointment_setting2

        subject
        expect(response).to have_http_status(200)
        expect(json['data']['id']).to eq('monday')
        expect(json['data']['periods']).to eq([{"start_time"=>"08:45", "end_time"=>"12:00"}, {"start_time"=>"21:45", "end_time"=>"23:59"}])
      end
    end

    context 'when update error' do
      it 'should get error' do
        params[:data][:periods] = [{start_time: "07:46", end_time: '08:00'}]

        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq("07:46-08:00 start time must before end time at least #{AppointmentSetting::MIN_DURATION_MIN}")
      end
    end
  end
end
