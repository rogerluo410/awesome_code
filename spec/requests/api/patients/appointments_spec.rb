RSpec.describe 'Patient appointments API requests', type: :request do
  include AppointmentContexts

  describe 'GET /v1/p/appointments/active' do
    subject { get '/v1/p/appointments/active', headers: headers}

    context 'when first appointment' do
      let(:headers) { token_headers(patient1) }

      it 'should return correct estimate time' do
        patient1_appointment1
        subject

        appointment = json['data']
        expect(appointment['estimate_consult_time']).to eq('11:00')
        expect(appointment['status']).to eq('pending')
      end
    end

    context 'when have already appointment' do
      let(:headers) { token_headers(patient2) }

      it 'should return correct estimate time' do
        patient1_appointment1
        patient2_appointment2
        subject

        appointment = json['data']
        expect(appointment['estimate_consult_time']).to eq('11:12')
        expect(appointment['status']).to eq('pending')
      end
    end

    context 'when none appointment' do
      let(:headers) { token_headers(patient2) }

      it 'should return nil' do
        subject

        expect(json['data']).to eq(nil)
      end
    end
  end

  #should add more spec


  describe 'POST /v1/p/appointments' do
    subject { post '/v1/p/appointments', headers: headers, params: params }

    let(:headers) { token_headers(patient1) }

    let(:params) {
      {
        appointment_setting_id: doctor1_setting1.id,
        doctor_id: doctor1.id,
        start_time: setting1_start_time,
        end_time: setting1_end_time,
      }
    }

    context 'when patient not sign in' do
      let(:headers) { {} }

      it 'should return authenticate error' do
        subject
        expect(response).to have_http_status(401)
        expect(json['error']['message']).to eq('User unauthorized.')
      end
    end

    context "when params is invalid" do
      it "validates start_time must not be blank" do
        params[:start_time] = nil
        subject
        expect_422_resp(response, "start_time and end_time must not be blank.")
      end

      it "validates end_time must not be blank" do
        params[:end_time] = nil
        subject
        expect_422_resp(response, "start_time and end_time must not be blank.")
      end

      it "validates start_time and end_time not match the appontment setting" do
        params[:start_time] = setting2_start_time
        params[:end_time] = setting2_end_time
        subject
        expect_422_resp(response, "Start-time and End-time do not match the time in appointment settings")
      end

      it "should be error doctor_id must not be blank" do
        params[:doctor_id] = nil
        subject
        expect_422_resp(response, "doctor_id must not be blank.")
      end

      it "should be error cannot find appontment setting" do
        params[:appointment_setting_id] = 100
        subject
        expect_422_resp(response, "Cannot find appontment setting by id 100.")
      end
    end

    context "when params is valid" do
      it 'should create appointment successfully with appointment' do
        subject
        expect(response).to have_http_status(201)

        doctor1_setting1.reload

        expect(doctor1_setting1.appointment_products.count).to eq(1)
        appointment_product = doctor1_setting1.appointment_products.last
        expect(appointment_product.start_time).to eq(setting1_start_time)
        expect(appointment_product.end_time).to eq(setting1_end_time)
        expect(appointment_product.appointments.count).to eq(1)
        expect(appointment_product.appointments.first.consultation_fee).to eq(appointment_product.consultation_fee)
      end

      context "when patient and doctor are in different time zone" do
        let(:params) {
          {
            doctor_id: doctor2.id,
            appointment_setting_id: doctor2_setting.id,
            start_time: '2016-05-24 22:00'.in_time_zone(perth),
            end_time: '2016-05-24 23:00'.in_time_zone(perth),
          }
        }

        it "can appoint today's appointment (based on patient time zone)" do
          subject
          expect(response).to have_http_status(201)
        end
      end

      context "when booking time block other than today" do
        let(:params) {
          {
            doctor_id: doctor1.id,
            appointment_setting_id: doctor1_setting3.id,
            start_time: '2016-05-25 09:00'.in_time_zone(perth),
            end_time: '2016-05-25 10:00'.in_time_zone(perth),
          }
        }

        it "fails" do
          subject
          expect_422_resp(response, "You can only book the doctor in future time today.")
        end
      end

      it "should be faild when patient already has an appointment" do
        patient1_appointment1
        subject
        expect_422_resp(response, "You have already booked an appointment today, Please waiting for the consultation.")
      end

      it "should be faild when slots is full" do
        patient2_appointment1
        params[:appointment_setting_id] = doctor1_setting2.id
        params[:start_time] = setting2_start_time
        params[:end_time] = setting2_end_time

        subject
        expect_422_resp(response, "There is no free slot to book an appointment at this period")
      end

    end
  end

  describe "PUT  /v1/p/appointments/:id/transfer" do
    subject {
         put  "/v1/p/appointments/#{patient1_appointment1.id}/transfer",
         headers: headers,
         as: :json
     }
     let(:headers) { token_headers(patient1) }

     context "Transfer event." do
       it "Transfer successfully." do
         patient1_appointment1.charge_event.update(status: 1)
         patient1_appointment1.update(status: 4, doctor_fee: '1')
         subject

         expect(response).to have_http_status(201)
         expect(patient1_appointment1.transfer_event_logs.where(status: 1).count).to be > 0
       end
     end
  end

  describe "PUT  /v1/p/appointments/:id/refund" do
    subject {
         put  "/v1/p/appointments/#{patient1_appointment1.id}/refund",
         headers: headers,
         as: :json
     }
     let(:headers) { token_headers(patient1) }

     context "Refund request event." do
       it "Refund successfully." do
         patient1_appointment1.charge_event.update(status: 1)
         patient1_appointment1.transfer_event.update(status: 1)
         patient1_appointment1.update(status: 4, doctor_fee: '1')
         charge_event_log.charge_event = patient1_appointment1.charge_event
         transfer_event_log.transfer_event = patient1_appointment1.transfer_event
         subject

         expect(response).to have_http_status(201)
         expect(patient1_appointment1.refund_request.present?).to be true
       end
     end
  end

  describe "GET  /v1/p/appointments/finished" do
    subject {
         get  "/v1/p/appointments/finished",
         headers: headers,
         as: :json
     }
     let(:headers) { token_headers(patient1) }

     context "When patient has finished appointments." do
       it "Get finished appointments successfully." do
         patient1_appointment1.update(status: 4)
         subject

         expect(response).to have_http_status(200)
         expect(patient1.appointments.ended.count).to eq(1)
       end
     end
  end

end
