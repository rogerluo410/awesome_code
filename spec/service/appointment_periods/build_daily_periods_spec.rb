RSpec.describe AppointmentPeriods::BuildDailyPeriods do
  before do
    travel_to Time.parse("2016-7-18 10:00 +10")
  end

  let(:perth_timezone){"Australia/Perth"}
  let(:sydney_timezone){"Australia/Sydney"}
  let(:patient) {create(:patient, local_timezone: perth_timezone)}
  let(:doctor) {create(:doctor, local_timezone: perth_timezone)}

  let(:sunday_setting1) {create(:appointment_setting, start_time: "22:00", end_time: "23:00", week_day: "sunday", doctor: doctor)}
  let(:sunday_setting2) {create(:appointment_setting, start_time: "23:00", end_time: "23:59", week_day: "sunday", doctor: doctor)}

  let(:monday_setting1) {create(:appointment_setting, start_time: "00:00", end_time: "01:00", week_day: "monday", doctor: doctor)}
  let(:monday_setting2) {create(:appointment_setting, start_time: "01:00", end_time: "02:00", week_day: "monday", doctor: doctor)}
  let(:monday_setting3) {create(:appointment_setting, start_time: "02:00", end_time: "03:00", week_day: "monday", doctor: doctor)}
  let(:monday_setting4) {create(:appointment_setting, start_time: "07:00", end_time: "08:00", week_day: "monday", doctor: doctor)}
  let(:monday_setting5) {create(:appointment_setting, start_time: "10:00", end_time: "11:00", week_day: "monday", doctor: doctor)}
  let(:monday_setting6) {create(:appointment_setting, start_time: "11:00", end_time: "12:00", week_day: "monday", doctor: doctor)}
  let(:monday_setting7) {create(:appointment_setting, start_time: "23:00", end_time: "23:59", week_day: "monday", doctor: doctor)}

  let(:tuesday_setting1) {create(:appointment_setting, start_time: "00:00", end_time: "01:00", week_day: "tuesday", doctor: doctor)}
  let(:tuesday_setting2) {create(:appointment_setting, start_time: "01:00", end_time: "02:00", week_day: "tuesday", doctor: doctor)}

  let(:params) {
    {
      id: doctor.id,
      date: "2016-07-18",
      timezone: perth_timezone,
    }
  }
  subject { AppointmentPeriods::BuildDailyPeriods.call(params) }

  describe "visit service method call success" do
    context "when there is no appointment_settings" do
      it "should be success" do
        expect(subject).to be_success
        expect(subject.result.count).to eq(0)
      end
    end

    context 'when current time in the period' do
      it "should be success" do
        monday_setting6
        travel_to Time.parse("2016-7-18 11:36 +8")

        expect(subject).to be_success
        expect(subject.result.count).to eq(1)
        expect(subject.result.first.start_time).to eq(Time.parse("2016-7-18 11:00 +8"))
        expect(subject.result.first.end_time).to eq(Time.parse("2016-7-18 12:00 +8"))
        expect(subject.result.first.price).to eq(37.5)
        expect(subject.result.first.booked_slots).to eq(0)
        expect(subject.result.first.remain_slots).to eq(2)
        expect(subject.result.first.estimation_time).to eq(Time.parse("2016-7-18 11:36 +8"))
      end
    end

    context 'when already exist an appointment' do
      it "should be success" do
        monday_setting6
        appointment_product = create(:appointment_product, doctor: doctor, start_time: Time.parse("2016-7-18 11:00 +8"), end_time: Time.parse("2016-7-18 12:00 +8"), appointment_setting: monday_setting6)
        appointment = create(:appointment, appointment_product: appointment_product, patient: patient, doctor: doctor)

        expect(subject).to be_success
        expect(subject.result.count).to eq(1)
        expect(subject.result.first.start_time).to eq(Time.parse("2016-7-18 11:00 +8"))
        expect(subject.result.first.end_time).to eq(Time.parse("2016-7-18 12:00 +8"))
        expect(subject.result.first.price).to eq(37.5)
        expect(subject.result.first.booked_slots).to eq(1)
        expect(subject.result.first.remain_slots).to eq(4)
        expect(subject.result.first.estimation_time).to eq(Time.parse("2016-7-18 11:12 +8"))
      end
    end

    context "when exist appointment settings" do
      before :each do
        sunday_setting1
        sunday_setting2
        (1..7).to_a.each{|x| eval("monday_setting#{x}")}
        tuesday_setting1
        tuesday_setting2
      end

      context "when doctor and patient in same timezone" do
        it "should be success" do
          expect(subject).to be_success
          expect(subject.result.count).to eq(7)
          expect(subject.result.first.start_time).to eq(Time.parse("2016-7-18 00:00 +8"))
          expect(subject.result.first.end_time).to eq(Time.parse("2016-7-18 01:00 +8"))
          expect(subject.result.first.price).to eq(99)
          expect(subject.result.first.booked_slots).to eq(0)
          expect(subject.result.first.remain_slots).to eq(0)
          expect(subject.result.first.estimation_time).to eq(Time.parse("2016-7-18 01:00 +8"))

          expect(subject.result.last.start_time).to eq(Time.parse("2016-7-18 23:00 +8"))
          expect(subject.result.last.end_time).to eq(Time.parse("2016-7-18 23:59 +8"))
          expect(subject.result.last.booked_slots).to eq(0)
          expect(subject.result.last.remain_slots).to eq(4)
          expect(subject.result.last.price).to eq(49.95)
          expect(subject.result.last.estimation_time).to eq(Time.parse("2016-7-18 23:00 +8"))
        end
      end

      context 'when doctor 2h before patient' do
        it "will return the settings including next day 00:00 - 02:00 for doctor" do
          doctor.local_timezone = sydney_timezone
          doctor.save 

          expect(subject).to be_success
          expect(subject.result.count).to eq(7)

          expect(subject.result.first.start_time).to eq(Time.parse("2016-7-18 02:00 +10"))
          expect(subject.result.first.end_time).to eq(Time.parse("2016-7-18 03:00 +10"))
          expect(subject.result.first.booked_slots).to eq(0)
          expect(subject.result.first.remain_slots).to eq(0)
          expect(subject.result.first.price).to eq(99)
          expect(subject.result.first.estimation_time).to eq(Time.parse("2016-7-18 03:00 +10"))

          expect(subject.result.last.start_time).to eq(Time.parse("2016-7-19 01:00 +10"))
          expect(subject.result.last.end_time).to eq(Time.parse("2016-7-19 02:00 +10"))
          expect(subject.result.last.price).to eq(99)
          expect(subject.result.last.booked_slots).to eq(0)
          expect(subject.result.last.remain_slots).to eq(5)
          expect(subject.result.last.estimation_time).to eq(Time.parse("2016-7-19 01:00 +10"))
        end
      end

      context 'when doctor 2h behind patient' do
        it "will return the settings including previous day 22:00 - 23:59 for doctor" do
          patient.local_timezone = sydney_timezone
          doctor.local_timezone = perth_timezone
          patient.save 
          doctor.save 
          params[:timezone] = sydney_timezone

          expect(subject).to be_success
          expect(subject.result.count).to eq(8)

          expect(subject.result.first.start_time).to eq(Time.parse("2016-7-17 22:00 +8"))
          expect(subject.result.first.end_time).to eq(Time.parse("2016-7-17 23:00 +8"))
          expect(subject.result.first.booked_slots).to eq(0)
          expect(subject.result.first.remain_slots).to eq(0)
          expect(subject.result.first.price).to eq(49.95)
          expect(subject.result.first.estimation_time).to eq(Time.parse("2016-7-17 23:00 +8"))

          expect(subject.result.last.start_time).to eq(Time.parse("2016-7-18 11:00 +8"))
          expect(subject.result.last.end_time).to eq(Time.parse("2016-7-18 12:00 +8"))
          expect(subject.result.last.price).to eq(37.5)
          expect(subject.result.last.booked_slots).to eq(0)
          expect(subject.result.last.remain_slots).to eq(5)
          expect(subject.result.last.estimation_time).to eq(Time.parse("2016-7-18 11:00 +8"))
        end
      end
    end
  end
end
