RSpec.describe "doctor upload medical certificate" do
  include AppointmentContexts

  describe "GET  /v1/d/appointments/:appointment_id/medical_certificate" do
    subject {
      get  "/v1/d/appointments/#{patient1_appointment1.id}/medical_certificate",
        headers: headers,
        as: :json
     }

     context "When a doctor posted a medical certificate for an appointment." do
       let(:headers) { token_headers(doctor1) }
       it "Get the medical certificate detail." do
         medical_certificate_1
         subject

         expect(response).to have_http_status(200)
         expect(::MedicalCertificate.where(appointment: medical_certificate_1).count).to eq(1)
       end
     end
  end

  describe "POST /v1/d/appointments/:appointment_id/medical_certificate" do
    subject {
      post  "/v1/d/appointments/#{patient2_appointment2.id}/medical_certificate",
        headers: headers,
        params: {
          file:   Rack::Test::UploadedFile.new("#{Rails.root}/spec/requests/api/doctor/upload_test.txt")
        }
     }

     context "When a doctor is going to post a medical certificate for an appointment which has no medical certificate even." do
       let(:headers) { token_headers(doctor1) }
       it "Post the medical certificate successfully." do
         subject

         expect(response).to have_http_status(200)
         expect(doctor1.appointments.find(patient2_appointment2.id).medical_certificate.file_identifier).to eq('upload_test.txt')
       end
     end
  end

  describe "DELETE  /v1/d/appointments/:appointment_id/medical_certificate" do
     subject {
      delete  "/v1/d/appointments/#{patient1_appointment1.id}/medical_certificate",
        headers: headers
     }

     context "When a doctor is going to DELETE a medical certificate for an appointment." do
       let(:headers) { token_headers(doctor1) }
       it "Delete the medical certificate successfully." do
         medical_certificate_1
         subject

         expect(response).to have_http_status(204)
       end
     end
  end


end
