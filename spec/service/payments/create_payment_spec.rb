RSpec.describe Payments::CreatePayment do
  let(:stripe_charge_id) { 'ch_123' }
  let(:patient) {create(:patient)}
  let(:checkout) { build(:checkout, patient: patient) }
  let(:doctor) { create(:doctor, :with_bank_account) }
  let(:appointment_setting) { create(:appointment_setting, doctor: doctor, start_time: "07:00", end_time: "13:00", week_day: "tuesday") }
  let(:appointment_product) { create(:appointment_product, doctor: doctor, start_time: Time.parse("2016-5-24 7:00 +10"), end_time: Time.parse("2016-5-24 13:00 +10"), appointment_setting: appointment_setting) }

  let(:appointment) { create(:appointment, patient: patient, doctor: doctor, appointment_product: appointment_product, consultation_fee: appointment_setting.consultation_fee, doctor_fee: appointment_setting.doctor_fee, status: :pending) }
  let(:mock_charge_result) { double(Stripe::Charge, id: stripe_charge_id, status: 'succeeded', source: {last4: '1881', brand: 'Visa'}) }
  let(:patient_params) {{patient: patient}}
  let(:params) {
    {
      appointment_id: appointment.id,
      checkout_id: checkout.id
    }
  }

  before do
    travel_to Time.parse("2016-5-24 10:00 +10")

    allow(PushData::AppPaid).to receive(:call)

    charge_result = double("Stripe::Charge",
      id: SecureRandom.hex,
      status: 'succeeded',
      source: { last4: '1111', brand: 'Visa' },
    )

    allow(Stripe::Charge).to(
      receive(:create)
        .with(any_args)
        .and_return(charge_result)
    )

    # FIXME this is to bypass the bank account validation.
    # the validation checks if the stripe account exist. It's useless and makes stripe API call very
    # frequently in the test. The logic should be moved to service object.
    allow(Stripe::Account).to(
      receive(:retrieve).and_return(1)
    )

    customer = double(Stripe::Customer, id: checkout.stripe_customer_id)
    allow(Stripe::Customer).to receive(:retrieve).with(checkout.stripe_customer_id).and_return(customer)
    checkout.save
  end

  after do
    travel_back
  end

  subject { Payments::CreatePayment.call(patient_params[:patient], params) }

  describe "visit service method call" do
    context "with invalid params" do
      it "should be failure when appointment_id is nil" do
        params[:appointment_id] = nil
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["appointment id can not be blank"]})
      end

      it "should be failure when appointment_id is invalid" do
        params[:appointment_id] = 100
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["appointment id is invalid"]})
      end

      it "should be failure when doctor bank is nil" do
        doctor.bank_account = nil
        doctor.save
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["Doctor does not have a bank account"]})
      end

      it "should be failure when appointment not in pending" do
        appointment.update(status: :accepted)
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["appointment already accepted"]})
      end

      it "should be failure when appointment_id is nil" do
        params[:checkout_id] = nil
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["checkout id can not be blank"]})
      end


      it "should be failure when checkout_id is invalid" do
        params[:checkout_id] = 100
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["checkout id is invalid"]})
      end

      it "should be failure when appointment is charging" do
        appointment.charge_event.update(status: :processing)
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["consultation fee is paying, please wait for a while"]})
      end
    end

    context "with valid params" do
      it "should be success" do
        allow(Stripe::Charge).to receive(:create)
                                  .with(amount: (appointment.consultation_fee.to_f * 100).to_i, currency: 'aud', customer: checkout.stripe_customer_id, description: 'charge for appointment').
                                  and_return(mock_charge_result)
        expect(subject).to be_success
        appointment.reload
        expect(appointment.charge_event.status).to eq(:succeeded)

        expect(PushData::AppPaid).to have_received(:call)
      end

      it "should be failure" do
        allow(Stripe::Charge).to receive(:create)
                                  .with(amount: (appointment.consultation_fee.to_f * 100).to_i, currency: 'aud', customer: checkout.stripe_customer_id, description: 'charge for appointment').
                                  and_raise(Stripe::APIConnectionError.new("Unexpected error communicating when trying to connect to Stripe."))
        expect(subject).to be_failure
        expect(subject.errors.messages).to eq({:base => ["Charge failed, please try with another card."]})
        expect(appointment.charge_event.status).to eq(:failed)
      end
    end
  end
end
