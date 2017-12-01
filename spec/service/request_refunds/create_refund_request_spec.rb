RSpec.describe RefundRequests::CreateRefundRequest do
  before do
    travel_to Time.parse("2016-5-24 10:00 +10")
  end

  let(:stripe_charge_id) { 'ch_123' }
  let(:checkout) { build(:checkout) }
  let(:patient) {create(:patient)}
  let(:bank_account) {create(:bank_account)}
  let(:doctor) {create(:doctor, bank_account: bank_account)}
  let(:appointment_setting) { create(:appointment_setting, doctor: doctor, start_time: "07:00", end_time: "13:00", week_day: "tuesday") }
  let(:appointment_product) { create(:appointment_product, doctor: doctor, start_time: Time.parse("2016-5-24 7:00 +10"), end_time: Time.parse("2016-5-24 13:00 +10"), appointment_setting: appointment_setting) }

  let(:appointment) { create(:appointment, patient: patient, doctor: doctor, appointment_product: appointment_product, consultation_fee: appointment_setting.consultation_fee, doctor_fee: appointment_setting.doctor_fee, status: :finished) }

  let(:charge_event_log) { create(:charge_event_log, charge_event: appointment.charge_event, status: :succeeded) }
  let(:transfer_event_log) { create(:transfer_event_log, transfer_event: appointment.transfer_event, status: :paid) }

  let(:params) {
    {
      appointment_id: appointment.id,
    }
  }

  before :each do
    appointment.charge_event.update(status: :succeeded)
    charge_event_log
  end

  subject { RefundRequests::CreateRefundRequest.call(patient, params) }

  describe "visit service method call" do
    context "with invalid params" do
      it "should be failure when appointment_id is nil" do
        params[:appointment_id] = nil
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["appointment_id can not be blank."]})
      end

      it "should be failure when appointment_id is invalid" do
        params[:appointment_id] = 100
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["appointment_id is invalid."]})
      end

      it "should be failure when appointment not finished" do
        appointment.update(status: :accepted)
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["Appointment not finished."]})
      end

      it "should be failure when appointment not paid" do
        appointment.charge_event.update(status: :failed)
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["Appointment not paid."]})
      end

      it "should be failure when appointment already have a refund request" do
        appointment.create_refund_request

        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["Appointment has already requested for refund."]})
      end
    end

    context "with valid params" do
      it "should be success when not transfer to doctor" do
        expect(subject).to be_success
        appointment.reload
        expect(appointment.refund_request.charge_event_log).to eq(charge_event_log)
        expect(appointment.refund_request.transfer_event_log).to eq(nil)
      end

      it "should be success when already transfer to doctor" do
        appointment.transfer_event.update(status: :succeeded)
        transfer_event_log

        expect(subject).to be_success
        appointment.reload
        expect(appointment.refund_request.charge_event_log).to eq(charge_event_log)
        expect(appointment.refund_request.transfer_event_log).to eq(transfer_event_log)
      end
    end
  end
end
