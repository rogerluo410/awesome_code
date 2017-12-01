RSpec.describe "Doctors API" do
  let(:patient) { create(:patient, local_timezone: 'Australia/Sydney') }

  let!(:doctor1) { create(:doctor, local_timezone: 'Australia/Sydney') }
  let!(:doctor_profile1) { create(:doctor_profile, approved: true, user_id: doctor1.id) }
  let!(:doctor2) { create(:doctor, local_timezone: 'Australia/Perth') }
  let!(:doctor_profile2) { create(:doctor_profile, approved: true, user_id: doctor2.id) }
  let!(:appointment_setting1) { create(:appointment_setting, user_id: doctor1.id, week_day: "tuesday", start_time: "03:00", end_time: "06:00") }
  let!(:appointment_setting2) { create(:appointment_setting, user_id: doctor2.id, week_day: "tuesday", start_time: "08:00", end_time: "09:00") }
  let!(:appointment_setting3) { create(:appointment_setting, user_id: doctor2.id, week_day: "monday", start_time: "20:00", end_time: "23:00") }
  let!(:appointment_setting4) { create(:appointment_setting, user_id: doctor1.id, week_day: "wednesday", start_time: "00:00", end_time: "02:00") }

  before :each do
    travel_to Time.parse("2016-6-7 10:00 +10")
    Doctor.__elasticsearch__.refresh_index!
  end

  describe 'GET /v1/doctors' do
    describe 'match match_api_schema' do
      context 'when correct' do
        it 'return match_api_schema' do
          get '/v1/doctors', params: {date: '2016-6-7', from: '02', to: '04', page: 0, tz: 'Australia/Sydney'}

          expect(response).to have_http_status(200)
          expect(response).to match_api_schema(:doctor, layout: :paginated_list)
        end
      end
    end

    describe 'match the api return content' do
      context 'when no doctors match the condition' do
        it 'return json api data is []' do
          get '/v1/doctors', params: {date: '2016-6-7', from: '14', to: '15', page: 0, tz: 'Australia/Sydney'}

          expect(json['data']).to eq([])
        end
      end

      #con't correct
      context 'when only start_time at from to period and doctors are in same day with patient' do
        it 'return json data correct' do
          appintment_periods = [
            {
              "id"=>1,
              "start_time"=>"2016-06-07T03:00:00.000+10:00",
              "end_time"=>"2016-06-07T06:00:00.000+10:00",
              "week_day"=>"tuesday",
              "available_slots"=>0
            }
          ]

          get '/v1/doctors', params: {date: '2016-6-7', from: '00', to: '01', page: 0, tz: 'Australia/Perth'}

          expect(json['data'].count).to eq(1)
          expect(json['data'].first['id']).to eq(doctor1.id)
          expect(json['data'].first['appointment_periods']).to eq(appintment_periods)
        end
      end

      context 'when only end_time at from to period and doctors are in same day with patient' do
        it 'return json data correct' do
          appintment_periods = [
            {
              "id"=>1,
              "start_time"=>"2016-06-07T03:00:00.000+10:00",
              "end_time"=>"2016-06-07T06:00:00.000+10:00",
              "week_day"=>"tuesday",
              "available_slots"=>0
            }
          ]

          get '/v1/doctors', params: {date: '2016-6-7', from: '00', to: '05', page: 0, tz: 'Australia/Perth'}

          expect(json['data'].count).to eq(1)
          expect(json['data'].first['id']).to eq(doctor1.id)
          expect(json['data'].first['appointment_periods']).to eq(appintment_periods)
        end
      end

      context 'when start_time > from and end_time <to and doctors are in same day with patient' do
        it 'return json data correct' do
          appintment_periods = [
            {
              "id"=>1,
              "start_time"=>"2016-06-07T03:00:00.000+10:00",
              "end_time"=>"2016-06-07T06:00:00.000+10:00",
              "week_day"=>"tuesday",
              "available_slots"=>0
            }
          ]

          get '/v1/doctors', params: {date: '2016-6-7', from: '03', to: '05', page: 0, tz: 'Australia/Perth'}

          expect(json['data'].count).to eq(1)
          expect(json['data'].first['id']).to eq(doctor1.id)
          expect(json['data'].first['appointment_periods']).to eq(appintment_periods)
        end
      end

      context 'when start_time < from and end_time > to and doctors are in same day with patient' do
        it 'return json data correct' do
          appintment_periods = [
            {
              "id"=>1,
              "start_time"=>"2016-06-07T03:00:00.000+10:00",
              "end_time"=>"2016-06-07T06:00:00.000+10:00",
              "week_day"=>"tuesday",
              "available_slots"=>0
            }
          ]

          get '/v1/doctors', params: {date: '2016-6-7', from: '02', to: '03', page: 0, tz: 'Australia/Perth'}
          expect(json['data'].count).to eq(1)
          expect(json['data'].first['id']).to eq(doctor1.id)
          expect(json['data'].first['appointment_periods']).to eq(appintment_periods)
        end
      end

      context 'when has doctors in previous day to patient' do
        it 'return json data correct' do
          appintment_periods = [
            {
              "id"=>3,
              "start_time"=>"2016-06-06T20:00:00.000+08:00",
              "end_time"=>"2016-06-06T23:00:00.000+08:00",
              "week_day"=>"monday",
              "available_slots"=>0
            }
          ]

          get '/v1/doctors', params: {date: '2016-6-7', from: '00', to: '02', page: 0, tz: 'Australia/Sydney'}

          expect(json['data'].count).to eq(1)
          expect(json['data'].first['id']).to eq(doctor2.id)
          expect(json['data'].first['appointment_periods']).to eq(appintment_periods)
        end
      end

      context 'when has doctors in next day to patient' do
        it 'retrun json data correct' do
          appintment_periods = [
            {
              "id"=>4,
              "start_time"=>"2016-06-08T00:00:00.000+10:00",
              "end_time"=>"2016-06-08T02:00:00.000+10:00",
              "week_day"=>"wednesday",
              "available_slots"=>10
            }
          ]

          get '/v1/doctors', params: {date: '2016-6-7', from: '22', to: 'end_of_day', page: 0, tz: 'Australia/Perth'}

          expect(json['data'].count).to eq(1)
          expect(json['data'].first['id']).to eq(doctor1.id)
          expect(json['data'].first['appointment_periods']).to eq(appintment_periods)
        end
      end

      context 'when input from large than to, will errors' do
        it 'return json data correct' do
          appintment_periods = [
            {
              "id"=>1,
              "start_time"=>"2016-06-07T03:00:00.000+10:00",
              "end_time"=>"2016-06-07T06:00:00.000+10:00",
              "week_day"=>"tuesday",
              "available_slots"=>0
            }
          ]

          get '/v1/doctors', params: {date: '2016-6-7', from: '03', to: '01', page: 0, tz: 'Australia/Perth'}

          expect_422_resp(response, 'from must little than to')
        end
      end
    end
  end

  describe 'GET /v1/doctors/:id/profile' do
    subject { get "/v1/doctors/#{doctor1.id}/profile", headers: token_headers(patient) }

    context 'when url is correct' do
      it 'should match_api_schema' do
        subject
        expect(response).to have_http_status(200)
        expect(response).to match_api_schema(:doctor_profile)
      end
    end
  end

  describe 'GET /v1/doctors/:id/appointment_periods' do
    let(:params) {
      {
        # 2016-6-7 is monday
        date: '2016-6-7',
      }
    }

    let(:headers) { token_headers(patient) }
    subject { get "/v1/doctors/#{doctor1.id}/appointment_periods", headers: headers, params: params }

    context 'when date is blank' do
      it 'should be failed' do
        params[:date] = nil
        subject
        expect_422_resp(response, "Date can't be blank")
      end
    end

    context "when doctor id is invalid" do
      it 'should be failed' do
        id = 100
        get "/v1/doctors/#{id}/appointment_periods", headers: headers, params: params
        expect_422_resp(response, "Can not find doctor with id #{id}")
      end
    end

    context "when there isn't settings for that day" do
      it "should be an empty array" do
        # 2016-6-6 is sunday
        params[:date] = '2016-6-6'
        subject
        expect(response).to have_http_status(200)
        expect(json['data'].count).to eq(0)
      end
    end

    context "when there exist settings for that day" do
      it "should return the data" do
        travel_to Time.parse('2016-6-7 05:00 +10')
        subject
        expect(response).to have_http_status(200)
        expect(response).to match_api_schema(:appointment_period, layout: :list)
      end
    end
  end

  describe 'GET /v1/doctors/:id/appointment_periods without sign in' do
    let(:params) {
      {
        # 2016-6-7 is monday
        date: '2016-6-7',
        timezone: 'Australia/Perth'
      }
    }

    subject { get "/v1/doctors/#{doctor1.id}/appointment_periods", headers: headers, params: params }

    context 'when date is blank' do
      it 'should be failed' do
        params[:date] = nil
        subject
        expect_422_resp(response, "Date can't be blank")
      end
    end

    context 'when timezone is blnak' do
      it 'should be failed' do
        params[:timezone] = nil
        subject
        expect_422_resp(response, "Timezone can't be blank")
      end
    end

    context "when doctor id is invalid" do
      it 'should be failed' do
        id = 100
        get "/v1/doctors/#{id}/appointment_periods", headers: headers, params: params
        expect_422_resp(response, "Can not find doctor with id #{id}")
      end
    end

    context "when there isn't settings for that day" do
      it "should be an empty array" do
        # 2016-6-6 is sunday
        params[:date] = '2016-6-6'
        subject
        expect(response).to have_http_status(200)
        expect(json['data'].count).to eq(0)
      end
    end

    context "when there exist settings for that day" do
      it "should return the data" do
        travel_to Time.parse('2016-6-7 05:00 +10')
        subject
        expect(response).to have_http_status(200)
        expect(response).to match_api_schema(:appointment_period, layout: :list)
      end
    end
  end
end
