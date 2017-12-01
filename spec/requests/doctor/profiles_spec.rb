RSpec.describe "Doctor profile request", type: :request do
  let(:doctor) { create(:doctor) }
  let(:doctor_profile) { create(:doctor_profile, user_id: doctor.id) }

  before do
    sign_in doctor
  end

  describe "GET /d/me" do
    it "should Show edit doctor profile page successfully" do
      get "/d/me"
      expect(response).to be_success
    end
  end

  describe "PUT /d/me" do
    let(:params) {
      {
          doctor: {
                phone: "12345678",
                first_name: "Grace",
                last_name: "Han",
                username: "Blues",
                local_timezone: "Australia/Sydney",
                doctor_profile_attributes: {
                  specialty_id: 2,
                  approved: true
                },
                address_attributes: {
                  country: "Australia",
                  postcode: "345456",
                  state: "New South Wales",
                  suburb: "wewew",
                  street_address: "12344",
                },
          }
      }
    }

    subject { put "/d/me", params: params }

    context "when update doctor profile without email" do
      it "should update doctor profile successfully" do
        subject
        doctor.reload
        expect(response).to redirect_to(doctor_profile_path)
        expect(flash[:notice]).to eq("Update successfully")
        doctor.reload
        expect(doctor.phone).to eq("12345678")
        expect(doctor.first_name).to eq("Grace")
        expect(doctor.last_name).to eq("Han")
        expect(doctor.username).to eq("Blues")
        expect(doctor.local_timezone).to eq("Australia/Sydney")
        expect(doctor.doctor_profile.specialty_id).to eq(2)
        expect(doctor.address.state).to eq("New South Wales")
      end
    end

    context "when subscribe no way to get notification" do
      it 'should return error message' do
        params = {
          doctor: {
            notify_sms: 0,
            notify_system: 0,
            notify_email: 0
          }
        }

        put "/d/me", params: params
        doctor.reload

        expect(response).to redirect_to(doctor_profile_path)

        expect(flash[:error][:base]).to eq(["You must keep one way to receive the notifications"])
      end
    end

    context "when update doctor profile with email" do
      it "should update doctor profile successfully and send a verification email" do
        params[:doctor][:email] = "changeemail@example.com"
        expect {subject}.to change(ActionMailer::Base.deliveries, :count).by(1)
        doctor.reload
        expect(response).to redirect_to(doctor_profile_url)
        expect(flash[:notice]).to eq("Your email has been changed to changeemail@example.com, and will be updated once you verify this address, please check your email and vifify the address.")
        expect(doctor.phone).to eq("12345678")
        expect(doctor.unconfirmed_email).to eq("changeemail@example.com")
        expect(doctor.first_name).to eq("Grace")
        expect(doctor.last_name).to eq("Han")
        expect(doctor.doctor_profile.specialty_id).to eq(2)
        expect(doctor.address.state).to eq("New South Wales")
      end
    end

    context "When update time_zone" do
      it 'Failed when time_zone is invalid' do
        params[:doctor][:local_timezone] = "InvalidTimeZone"
        subject
        doctor.reload
        expect(response).to redirect_to(doctor_profile_url)
        expect(flash[:error][:base] = "Timezone is invalid")
      end
    end
  end
end
