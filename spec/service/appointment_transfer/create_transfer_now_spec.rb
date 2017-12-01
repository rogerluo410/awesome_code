RSpec.describe AppointmentTransfers::CreateTransferNow do
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


  let(:params) {{ appointment_id: appointment.id }}

  subject { ::AppointmentTransfers::CreateTransferNow.call(patient, params) }

  before :each do
    appointment.charge_event.update(status: :succeeded)
  end

  describe "visit service method call" do
    context "with invalid params" do
      it "should be failure when appointment id is blank" do
        params[:appointment_id] = nil
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["appointment_id can not be blank"]})
      end

      it "should be failure when appointment id is invalid" do
        params[:appointment_id] = 123
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["appointment id is invalid"]})
      end
    end

    context "with valid appointment" do
      it "should be success" do
        allow(Stripe::Transfer).to receive(:create)
                                  .with(amount: (appointment.doctor_fee.to_f * 100).to_i, currency: 'aud', destination: bank_account.account_id, description: 'transfer for appointment').
                                  and_return(mock_transfer_result)
        expect(subject).to be_success
        appointment.reload
        expect(appointment.transfer_event.status).to eq(:succeeded)
      end

      it 'should be success and remove the exist transfer job' do
        appointment.default_transfer
        allow(Stripe::Transfer).to receive(:create)
                                  .with(amount: (appointment.doctor_fee.to_f * 100).to_i, currency: 'aud', destination: bank_account.account_id, description: 'transfer for appointment').
                                  and_return(mock_transfer_result)
        expect(subject).to be_success

        appointment.reload
        expect(appointment.transfer_event.status).to eq(:succeeded)
      end

      it "should be failure when stripe api error" do
        allow(Stripe::Transfer).to receive(:create)
                                  .with(amount: (appointment.doctor_fee.to_f * 100).to_i, currency: 'aud', destination: bank_account.account_id, description: 'transfer for appointment').
                                  and_raise(Stripe::APIConnectionError.new("Unexpected error communicating when trying to connect to Stripe."))
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["Transfer failed, please try it later."]})
        appointment.reload
        expect(appointment.transfer_event.status).to eq(:failed)
      end
    end
  end
end
