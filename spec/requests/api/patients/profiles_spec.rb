RSpec.describe 'Patient profile API requests', type: :request  do
  include AppointmentContexts

  describe "get /v1/p/profile" do
    subject {
      get "/v1/p/profile",
      headers: headers,
      as: :json
    }

    context "When a patient uploads a prescription file." do
      let(:headers) { token_headers(patient1) }
      it "gets  patient1's profile" do
        subject
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "put /v1/p/profile" do
    subject {
      put "/v1/p/profile",
      headers: headers,
      params: { data: {
        email: patient1.email,
        username: patient1.username,
        phone: patient1.phone,
        first_name: patient1.first_name,
        last_name: patient1.last_name,
        notify_email: patient1.notify_email,
        notify_system: patient1.notify_system,
        notify_sms: patient1.notify_sms,
        local_timezone: patient1.local_timezone,
        doctor_profile_attributes: {
          id: patient_profile.id,
          sex: patient_profile.sex,
          birthday: patient_profile.birthday
        },
        address_attributes: {
          id: address.id,
          postcode: address.postcode,
          state: address.state,
          suburb: address.suburb,
          street_address: address.street_address
        }
      } },
      as: :json
    }

    context "When a patient update his profile." do
      let(:headers) { token_headers(patient1) }
      let(:patient_profile) { FactoryGirl.create(:patient_profile, patient: patient1) }
      let(:address) { FactoryGirl.create(:address, user: patient1) }
      it "update patient1's profile successfully" do
        subject
        expect(response).to have_http_status(200)
      end
    end
  end

end
