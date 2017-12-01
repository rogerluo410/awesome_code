RSpec.describe AppointmentSetting, type: :model do
  let(:doctor) { create(:doctor) }

  let(:start_time) {"00:00"}
  let(:end_time) {"07:00"}
  let(:appointment_setting) {build(:appointment_setting, user_id: doctor.id, start_time: start_time,
                                        end_time: start_time, week_day: 'tuesday') }

  describe "test appointment_period_processor" do
    context 'responds to its methods' do
      it { expect(appointment_setting).to respond_to(:consultation_fee) }
      it { expect(appointment_setting).to respond_to(:application_fee) }
      it { expect(appointment_setting).to respond_to(:doctor_fee) }
    end

    context "when test instance methond" do
      it "should calculate with 00:00-07:00 period fee" do
        expect(appointment_setting.consultation_fee).to eq(99)
        expect(appointment_setting.application_fee).to eq(40)
        expect(appointment_setting.doctor_fee).to eq(59)
      end

      it "should calculate with 07:00-17:00 period fee" do
        appointment_setting.start_time = "07:00"
        appointment_setting.end_time = "17:00"
        expect(appointment_setting.consultation_fee).to eq(37.5)
        expect(appointment_setting.application_fee).to eq(17.5)
        expect(appointment_setting.doctor_fee).to eq(20)
      end

      it "should calculate with 17:00-23:59 period fee" do
        appointment_setting.start_time = "17:00"
        appointment_setting.end_time = "23:00"
        expect(appointment_setting.consultation_fee).to eq(49.95)
        expect(appointment_setting.application_fee).to eq(20.95)
        expect(appointment_setting.doctor_fee).to eq(29)
      end
    end
  end
end
