RSpec.describe PaymentGateways::CreateCharge do
  before do
    travel_to Time.parse("2016-5-24 10:00 +10")
  end

  let(:amount) { 1000.00 }
  let(:stripe_charge_id) { 'ch_123' }
  let(:checkout) { build(:checkout) }
  let(:patient) {create(:patient)}
  let(:doctor) {create(:doctor)}
  let(:amount) {100}
  let(:appointment_setting) { create(:appointment_setting, doctor: doctor, start_time: "07:00", end_time: "13:00", week_day: "tuesday") }
  let(:appointment_product) { create(:appointment_product, doctor: doctor, start_time: Time.parse("2016-5-24 7:00 +10"), end_time: Time.parse("2016-5-24 13:00 +10"), appointment_setting: appointment_setting) }
  let(:appointment) { create(:appointment, patient: patient, doctor: doctor, appointment_product: appointment_product) }
  let(:mock_charge_result) { double(Stripe::Charge, id: stripe_charge_id, status: 'succeeded', source: {last4: '1881', brand: 'Visa'}) }
  let(:tracker) { PaymentGateways::TrackChargeEvent.new(checkout: checkout, amount: amount, appointment: appointment) }

  subject { PaymentGateways::CreateCharge.call(tracker) }

  before :each do
    customer = double(Stripe::Customer, id: checkout.stripe_customer_id)
    allow(Stripe::Customer).to receive(:retrieve).with(checkout.stripe_customer_id).and_return(customer)
    checkout.save
  end

  it 'should be succeed with valid param' do
    allow(Stripe::Charge).to receive(:create)
                                  .with(amount: (amount.to_f).to_i, currency: 'aud', customer: checkout.stripe_customer_id, description: 'charge for appointment').
                                  and_return(mock_charge_result)
    expect(subject).to be_success
    expect(subject.result.status).to eq(1)
  end

  it 'create charge_event_log with faild status when stripe charge faild' do
    allow(Stripe::Charge).to receive(:create)
                                  .with(amount: (amount.to_f).to_i, currency: 'aud', customer: checkout.stripe_customer_id, description: 'charge for appointment').
                                  and_raise(Stripe::APIConnectionError.new("Unexpected error communicating when trying to connect to Stripe."))
    expect(subject).to be_success
    expect(subject.result.status).to eq(0)
  end

end
