RSpec.describe "Patient profile request", type: :request do
  let(:patient) { create(:patient) }
  let(:patient_profile) { create(:patient_profile, user_id: patient.id) }

  before :each do
    sign_in patient
  end

  describe "GET /p/me" do
    context "when visit edit profile page" do
      it "should show edit patient profile page successfully" do
        get "/p/me"
        expect(response).to be_success
      end
    end
  end

  describe "PATCH /p/me" do
    let(:params) {
      {
          patient: {
              phone: "12345678",
              first_name: "Margaret",
              last_name: "Yang",
              username: "sunshine",
              local_timezone: "Australia/Sydney",
              patient_profile_attributes: {
                sex: "male",
                birthday: Date.parse("1990-05-18")
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

    subject {patch "/p/me", params: params}

    context "when update patient profile without email" do
      it "should update successfully" do
        subject
        patient.reload
        expect(response).to redirect_to(patient_profile_path)
        expect(flash[:notice]).to eq("Update profile successfully")
        expect(patient.first_name).to eq("Margaret")
        expect(patient.username).to eq("sunshine")
        expect(patient.local_timezone).to eq("Australia/Sydney")
        expect(patient.patient_profile.sex).to eq("male")
        expect(patient.patient_profile.birthday).to eq(Date.parse("1990-05-18"))
      end
    end

    context "when update patient profile with email" do
      it "should update successfully" do
        params[:patient][:email] = "changeemail@example.com"
        expect {subject}.to change(ActionMailer::Base.deliveries, :count).by(1)
        patient.reload
        expect(response).to redirect_to(patient_profile_path)
        expect(flash[:notice]).to eq("Your email has been changed to changeemail@example.com, and will be updated once you verify this address, please check your email and vifify the address.")
        expect(patient.first_name).to eq("Margaret")
        expect(patient.patient_profile.sex).to eq("male")
        expect(patient.patient_profile.birthday).to eq(Date.parse("1990-05-18"))
      end

      it 'when subscribe no way to get notification' do
        params = {
          patient: {
            notify_sms: 0,
            notify_system: 0,
            notify_email: 0
          }
        }
        patch "/p/me", params: params
        patient.reload
        expect(response).to redirect_to(patient_profile_path)
        expect(flash[:error][:base]).to eq(["You must keep one way to receive the notifications"])
      end
    end

    context "When update time_zone" do
      it 'Failed when time_zone is invalid' do
        params[:doctor][:local_timezone] = "InvalidTimeZone"
        subject
        patient.reload
        expect(response).to redirect_to(patient_profile_path)
        expect(flash[:error][:base] = "Timezone is invalid")
      end
    end

  end
end
