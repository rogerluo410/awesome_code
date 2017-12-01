RSpec.describe Checkouts::Create do
  let(:valid_params) {
    {
      number: "4242424242424242",
      exp_month: 12,
      exp_year: 2020,
      cvc: '123',
    }
  }

  let(:patient) { FactoryGirl.create(:patient) }

  context "with real stripe API", slow: 'stripe' do
    after { @customer.delete if @customer }

    it "creates the customer" do
      service = described_class.call(patient, valid_params)
      @customer = service.customer

      expect(service).to be_success

      checkout = service.result
      expect(checkout).to be_persisted
      expect(checkout.stripe_customer_id).to eq @customer.id
    end

    it "fails for wrong cvc" do
      service = described_class.call(patient, valid_params.merge(cvc: '99'))
      @customer = service.customer

      expect(service).to be_failure
      expect(service.error).to eq "Your card's security code is invalid."
    end
  end

  context "with valid params" do
    it "creates checkout successfully" do
      card = {
        last4: '4242',
        brand: 'Visa',
        exp_month: 12,
        exp_year: 20,
        country: 'US',
        funding: 'credit',
      }

      customer = double(Stripe::Customer,
        id: SecureRandom.hex,
        sources: { data: [card] }
      )

      expect(Stripe::Customer).to(
        receive(:create).with(source: valid_params.merge(object: 'card')).and_return(customer)
      )

      service = described_class.call(patient, valid_params)

      expect(service).to be_success

      checkout = service.result
      expect(checkout).to be_persisted
      expect(checkout.patient).to eq patient
      expect(checkout.stripe_customer_id).to eq customer.id
      expect(checkout.card_last4).to eq card[:last4]
      expect(checkout.brand).to eq card[:brand]
      expect(checkout.exp_month).to eq card[:exp_month]
      expect(checkout.exp_year).to eq card[:exp_year]
      expect(checkout.country).to eq card[:country]
      expect(checkout.funding).to eq card[:funding]
    end
  end

  context "with invalid params" do
    before do
      allow(Stripe::Customer).to(
        receive(:create).with(any_args).and_raise("should not goes here!")
      )
    end

    it "fails with invalid exp_month" do
      service = described_class.call(patient, valid_params.merge(exp_month: 13))
      expect(service).to be_failure
      expect(service.error).to eq "exp_month must be less than or equal to 12"
    end

    it "fails with invalid exp_year" do
      service = described_class.call(patient, valid_params.merge(exp_year: 'abc'))
      expect(service).to be_failure
      expect(service.error).to eq "exp_year must be an integer"
    end
  end
end
