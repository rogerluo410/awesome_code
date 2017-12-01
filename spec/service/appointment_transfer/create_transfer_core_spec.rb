RSpec.describe AppointmentTransfers::CreateTransferCore do
  before do
    travel_to Time.parse("2016-5-24 07:30 +10")
  end

  let(:patient) {create(:patient)}
  let(:checkout) { create(:checkout) }
  let(:bank_account) {create(:bank_account)}
  let(:doctor) {create(:doctor, bank_account: bank_account)}

  let(:appointment_setting) { create(:appointment_setting, doctor: doctor, start_time: "07:00", end_time: "08:00", week_day: "tuesday") }
  let(:appointment_product) { create(:appointment_product, doctor: doctor, start_time: Time.parse("2016-5-24 7:00 +10"), end_time: Time.parse("2016-5-24 8:00 +10"), appointment_setting: appointment_setting) }
  let(:appointment) { create(:appointment, patient: patient, doctor: doctor, appointment_product: appointment_product, consultation_fee: appointment_setting.consultation_fee, doctor_fee: appointment_setting.doctor_fee, status: :finished) }
  let(:mock_transfer_result) { double(Stripe::Transfer, id: 'tr_123', status: 'paid') }

  let(:params) {{ appointment: appointment }}

  subject { ::AppointmentTransfers::CreateTransferCore.call(params[:appointment]) }

  before :each do
    appointment.charge_event.update(status: :succeeded)
  end

  describe "visit service method call" do

    context "with invalid appointment" do
      it "should be failure when appointment is blank" do
        params[:appointment] = nil
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["appointment is blank"]})
      end

      it "should be failure when appointment not paid" do
        appointment.charge_event.update(status: :failed)
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["appointment not paid"]})
      end

      it "should be failure when appointment not finished" do
        appointment.status = :processing
        appointment.save

        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["appointment not finished"]})
      end

      it "should be failure when appointment already transferred" do
        appointment.transfer_event.update(status: :succeeded)
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["consultation fee already transferred to doctor"]})
      end

      it "should be failure when doctor does not have an account" do
        doctor.bank_account = nil
        doctor.save

        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["doctor does not have a bank account"]})
      end

      it "should be failure when appointment is transferring the fee" do
        appointment.transfer_event.update(status: :processing)
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["consultation fee is transferring, please wait for a while"]})
      end
    end

    context "with valid appointment" do
      it "should be success" do
        allow(Stripe::Transfer).to receive(:create)
                                  .with(amount: (appointment.doctor_fee.to_f * 100).to_i, currency: 'aud', destination: bank_account.account_id, description: 'transfer for appointment').
                                  and_return(mock_transfer_result)
        expect(subject).to be_success
        expect(subject.result.status).to eq(1)
        expect(appointment.transfer_event.succeeded?).to eq(true)
      end

      it "should be failure" do
        allow(Stripe::Transfer).to receive(:create)
                                  .with(amount: (appointment.doctor_fee.to_f * 100).to_i, currency: 'aud', destination: bank_account.account_id, description: 'transfer for appointment').
                                  and_raise(Stripe::APIConnectionError.new("Unexpected error communicating when trying to connect to Stripe."))
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["Transfer failed, please try it later."]})
        expect(subject.result.status).to eq(0)
        expect(subject.result.error_message).to eq("Unexpected error communicating when trying to connect to Stripe.")
        expect(appointment.transfer_event.succeeded?).to eq(false)
      end
    end
  end
end
