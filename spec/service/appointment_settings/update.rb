RSpec.describe AppointmentSettings::Update do
  let(:doctor) {create(:doctor, local_timezone: 'Australia/Sydney')}
  let(:appointment_setting1) {create(:appointment_setting, start_time: "08:00", end_time: "09:00", week_day: "monday", doctor: doctor)}
  let(:appointment_setting2) {create(:appointment_setting, start_time: "07:00", end_time: "08:00", week_day: "monday", doctor: doctor)}

  let(:params) {
    {
      doctor: doctor,
      data: {
        id: "monday",
        periods: [
          {start_time: "08:30", end_time: "12:00"},
          {start_time: "14:00", end_time: "17:00"},
        ],
      }
    }
  }

  subject { AppointmentSettings::Update.call(params[:doctor], params[:data]) }

  describe "visit service method call success" do
    context "when doctor still have no appointment settings on that day" do
      it "should update success " do
        expect(subject).to be_success

        doctor.reload
        appointment_settings = doctor.appointment_settings

        expect(appointment_settings.count).to equal(7)
        expect(appointment_settings.first.start_time).to eq("08:30")
        expect(appointment_settings.first.end_time).to eq("09:00")
        expect(appointment_settings.first.week_day).to eq("monday")
        expect(appointment_settings.last.start_time).to eq("16:00")
        expect(appointment_settings.last.end_time).to eq("17:00")
      end
    end

    context "when doctor already have appointment_settings on that day" do
      it "should update success " do
        appointment_setting1
        appointment_setting2

        expect(subject).to be_success
        doctor.reload
        appointment_settings = doctor.appointment_settings

        expect(appointment_settings.count).to equal(7)
        expect(appointment_settings.first.start_time).to eq("08:30")
        expect(appointment_settings.first.end_time).to eq("09:00")
        expect(appointment_settings.first.week_day).to eq("monday")
        expect(appointment_settings.last.start_time).to eq("16:00")
        expect(appointment_settings.last.end_time).to eq("17:00")
      end
    end

    context "when doctor want to deleta all settings" do
      it "should delete all settings" do
        params[:data][:periods] = []
        expect(subject).to be_success

        doctor.reload
        appointment_settings = doctor.appointment_settings
        expect(appointment_settings.count).to equal(0)
      end
    end

    context "when one of end time is 23:59" do
      it "should update success" do
        params[:data][:periods] = [
          {start_time: "20:00", end_time: "22:00"},
          {start_time: "22:30", end_time: "23:59"},
        ]

        expect(subject).to be_success

        doctor.reload
        appointment_settings = doctor.appointment_settings.order(:end_time)
        expect(appointment_settings.count).to equal(4)
        expect(appointment_settings.last.start_time).to eq("23:00")
        expect(appointment_settings.last.end_time).to eq("23:59")
      end
    end
  end

  describe "visit service method call failed" do
    context "when params is invalid" do
      it "should be failed when periods is nil" do
        params[:data][:periods] = nil
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base=>["time_periods should not be nil"]})
      end

      it "should be failed when week_day is nil" do
        params[:data][:id] = nil
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base=>["Week day can't be blank"]})
      end

      it "should be failed when week_day is not valid" do
        params[:data][:id] = "modnay"
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base=>["modnay is not a valid weekday"]})
      end
    end

    context "when periods not valid" do
      it "should be failed when has repeat period" do
        params[:data][:periods] = [
          {start_time: "08:00", end_time: "09:00"},
          {start_time: "08:00", end_time: "09:00"},
        ]
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base=>["period 08:00-09:00 are repeated"]})
      end

      it "should be failed when start_time are mixed" do
        params[:data][:periods] = [
          {start_time: "08:00", end_time: "10:00"},
          {start_time: "08:30", end_time: "09:00"},
        ]
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base=>["period 08:30-09:00 are mixed with period 08:00-10:00"]})
      end

      it "should be failed when end_time are mixed" do
        params[:data][:periods] = [
          {start_time: "08:00", end_time: "10:00"},
          {start_time: "07:30", end_time: "08:30"},
        ]
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base=>["period 08:00-10:00 are mixed with period 07:30-08:30"]})
      end

      it "should be failed when start time is after end time" do
        params[:data][:periods] = [
          {start_time: "08:46", end_time: "09:00"},
        ]
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base=>["08:46-09:00 start time must before end time at least #{AppointmentSetting::MIN_DURATION_MIN}"]})
      end
    end
  end
end
