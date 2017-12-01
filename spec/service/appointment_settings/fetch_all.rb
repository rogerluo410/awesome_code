RSpec.describe AppointmentSettings::FetchAll do
  let(:doctor) {create(:doctor)}
  let(:appointment_setting1) {create(:appointment_setting, start_time: "08:45", end_time: "09:00", week_day: "monday", doctor: doctor)}
  let(:appointment_setting2) {create(:appointment_setting, start_time: "07:00", end_time: "08:00", week_day: "monday", doctor: doctor)}
  let(:appointment_setting3) {create(:appointment_setting, start_time: "10:00", end_time: "11:00", week_day: "monday", doctor: doctor)}
  let(:appointment_setting4) {create(:appointment_setting, start_time: "11:00", end_time: "12:00", week_day: "monday", doctor: doctor)}

  subject { AppointmentSettings::FetchAll.call(doctor) }

  describe "visit service method call success" do
    context "when there is no appointment_settings" do
      it "should be success" do
        expect(subject).to be_success
        expect(subject.result.count).to eq(7)
        expect(subject.result[0]).to eq({id: "monday", periods: []})
      end
    end

    context "when there is exist appointment_settings" do
      it "should be success" do
        appointment_setting1
        appointment_setting2
        appointment_setting3
        appointment_setting4

        expect(subject).to be_success

        expect(subject.result.count).to eq(7)
        expect(subject.result[0]).to eq({id: "monday", periods: [{:start_time=>"07:00", :end_time=>"08:00"}, {:start_time=>"08:45", :end_time=>"09:00"}, {:start_time=>"10:00", :end_time=>"12:00"}]})
        expect(subject.result[6]).to eq({id: "sunday", periods: []})
      end
    end
  end
end
