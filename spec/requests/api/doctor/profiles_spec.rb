RSpec.describe 'Doctor profile API requests', type: :request  do
  include AppointmentContexts

  describe "get /v1/d/profile" do
    subject {
      get "/v1/d/profile",
      headers: headers,
      as: :json
    }

    context "When a doctor uploads a prescription file." do
      let(:headers) { token_headers(doctor1) }
      it "gets  doctor1's profile" do
        subject
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "put /v1/d/profile" do
    subject {
      put "/v1/d/profile",
      headers: headers,
      params: { data: {
        email: doctor1.email,
        username: doctor1.username,
        phone: doctor1.phone,
        first_name: doctor1.first_name,
        last_name: doctor1.last_name,
        notify_email: doctor1.notify_email,
        notify_system: doctor1.notify_system,
        notify_sms: doctor1.notify_sms,
        local_timezone: doctor1.local_timezone,
        doctor_profile_attributes: {
          id: doctor_profile.id,
          years_experience: doctor_profile.years_experience,
          bio_info: doctor_profile.bio_info,
          specialty_id: 1
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

    context "When a doctor update his profile." do
      let(:headers) { token_headers(doctor1) }
      let(:doctor_profile) { FactoryGirl.create(:doctor_profile, doctor: doctor1) }
      let(:address) { FactoryGirl.create(:address, user: doctor1) }
      it "update doctor1's profile successfully" do
        subject
        expect(response).to have_http_status(200)
      end
    end
  end

end
