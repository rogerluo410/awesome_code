RSpec.describe Checkouts::Delete do
  context "with real stripe API", slow: 'stripe' do
    subject { described_class.(checkout) }

    let!(:customer) { Stripe::Customer.create }
    let!(:checkout) { FactoryGirl.create(:checkout, stripe_customer_id: customer.id) }

    after do
      customer.refresh
      customer.delete if customer && !customer.deleted?
    end

    it "deletes the stripe customer and checkout" do
      subject
      expect(subject).to be_success
      expect(subject.result).to be_destroyed
      expect(subject.customer).to be_deleted
    end
  end

  context "when retrieving customer fails" do
    subject { described_class.(checkout) }

    let(:checkout) { FactoryGirl.create(:checkout) }

    it "fails" do
      stripe_error = Stripe::InvalidRequestError.new("Fake message", nil)
      expect(Stripe::Customer).to(
        receive(:retrieve)
          .with(checkout.stripe_customer_id)
          .and_raise(stripe_error)
      )

      subject
      expect(subject).to be_failure
      expect(subject.error).to eq stripe_error.message

      checkout.reload
      expect(checkout).to be_persisted
    end
  end

  context "when deleting customer fails" do
    subject { described_class.(checkout) }

    let(:checkout) { FactoryGirl.create(:checkout) }

    it "fails" do
      customer = double(Stripe::Customer)

      stripe_error = Stripe::APIError.new("Fake message")
      expect(customer).to receive(:deleted?).and_return(false)
      expect(customer).to receive(:delete).and_raise(stripe_error)

      expect(Stripe::Customer).to(
        receive(:retrieve)
          .with(checkout.stripe_customer_id)
          .and_return(customer)
      )

      subject
      expect(subject).to be_failure
      expect(subject.error).to eq stripe_error.message

      checkout.reload
      expect(checkout).to be_persisted
    end
  end

  context "when both customer and checkout are deleted" do
    subject { described_class.(checkout) }

    let(:checkout) { FactoryGirl.create(:checkout) }

    it "success" do
      customer = double(Stripe::Customer)

      expect(customer).to receive(:deleted?).and_return(false)
      expect(customer).to receive(:delete)

      expect(Stripe::Customer).to(
        receive(:retrieve)
          .with(checkout.stripe_customer_id)
          .and_return(customer)
      )

      subject
      expect(subject).to be_success
      expect(subject.result).to be_destroyed
    end
  end
end
