RSpec.describe "doctor appointment products apis" do
  include AppointmentContexts

  describe "GET  /v1/d/appointment_products/scheduled" do
    subject {
      get  "/v1/d/appointment_products/scheduled",
        headers: headers,
        as: :json
     }

     context "A doctor has one appointment product today." do
       let(:headers) { token_headers(doctor1) }
       it "Get doctor today's appointment product " do
         setting3_product
         subject

         expect(response).to have_http_status(200)
         expect(::AppointmentProduct.get_doctor_scheduled(doctor1).count).to eq(1)
       end
     end
  end

end
