RSpec.describe "doctor appointment apis" do
  include AppointmentContexts

  describe "GET /v1/d/appointments/:id" do
     subject(:correct_request) {
         get  "/v1/d/appointments/#{patient1_appointment1.id}",
         headers: headers,
         as: :json
     }

     subject(:wrong_request) {
         get  "/v1/d/appointments/1000",
         headers: headers,
         as: :json
     }

     context "When a doctor gets the specified appointment." do
       let(:headers) { token_headers(doctor1) }
       it "Get appointment detail successfully." do
         correct_request

         expect(response).to have_http_status(200)
       end
     end

     context "When appointment id is invalid." do
       let(:headers) { token_headers(doctor1) }
       it "Resource not found" do
         wrong_request

         expect(response).to have_http_status(404)
       end
     end
  end

  describe "GET /v1/d/appointments/upcoming" do
     subject {
         get  "/v1/d/appointments/upcoming",
         headers: headers,
         as: :json
     }

     context "When a doctor gets  accepted and processing appointments." do
       let(:headers) { token_headers(doctor1) }
       it "Get appointments successfully." do
         patient1_appointment1.update(status: :accepted)
         patient2_appointment2.update(status: :processing)
         subject

         expect(response).to have_http_status(200)
         doctor1.reload
         expect(doctor1.appointments.where("status in (?)", [2, 3]).count).to eq(2)
       end
     end
  end

   describe "GET /v1/d/appointments/finished" do
     subject {
         get  "/v1/d/appointments/finished",
         headers: headers,
         as: :json
     }

     context "When a doctor gets  finished appointments." do
       let(:headers) { token_headers(doctor1) }
       it "Get appointments successfully." do
         patient1_appointment1.update(status: :finished)
         patient2_appointment2.update(status: :finished)
         subject

         expect(response).to have_http_status(200)
         doctor1.reload
         expect(doctor1.appointments.where("status = ?", 4).count).to eq(2)
       end
     end
  end

  describe "PUT   /v1/d/appointments/:id/approve" do
  	subject(:correct_request) {
         put  "/v1/d/appointments/#{patient1_appointment1.id}/approve",
         headers: headers,
         as: :json
  	}

      subject(:wrong_request) {
         put  "/v1/d/appointments/1000/approve",
         headers: headers,
         as: :json
      }

      context "When a doctor has an appointment." do
      	  let(:headers) { token_headers(doctor1) }
      	  it "The appointment is approved successfully when paid" do
            patient1_appointment1.create_charge_event(status: 1)
            correct_request
            expect(response).to have_http_status(200)
            doctor1.reload
            expect(doctor1.appointments.find(patient1_appointment1.id).status.to_s).to eq('accepted')
      	  end
      	end

       context "When appointment id is invalid" do
         let(:headers) { token_headers(doctor1) }
         it "Resource not found" do
            wrong_request

            expect(response).to have_http_status(404)
         end

         it "Approve failed when appointment has not been paid" do
           correct_request

           expect(response).to have_http_status(422)
           expect(json['error']['message']).to eq('The appointment has not been paid.')
         end
       end
  end

  describe "PUT /v1/d/appointments/:id/decline" do
  	subject(:correct_request) {
         put  "/v1/d/appointments/#{patient1_appointment1.id}/decline",
         headers: headers,
         as: :json
  	}

      subject(:wrong_request) {
         put  "/v1/d/appointments/1000/decline",
         headers: headers,
         as: :json
      }

       context "When a doctor has an appointment." do
         let(:headers) { token_headers(doctor1) }
         it "The appointment is declined successfully" do
           correct_request

           expect(response).to have_http_status(200)
           doctor1.reload
           expect(doctor1.appointments.find(patient1_appointment1.id).status.to_s).to eq('decline')
         end
       end

       context "When appointment id is invalid" do
         let(:headers) { token_headers(doctor1) }
         it "Resource not found" do
            wrong_request

            expect(response).to have_http_status(404)
         end
       end
  end

end
