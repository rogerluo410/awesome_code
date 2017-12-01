module PaymentGateways
  class CreateCharge
    include Serviceable

    attr_reader :checkout

    def initialize(tracker)
      @tracker = tracker
      @checkout = tracker.checkout
      @amount = tracker.amount
    end

    def call
      begin
        charge_result = Stripe::Charge.create(amount: @amount.to_i,
                                              currency: 'aud',
                                              customer: @checkout.stripe_customer_id,
                                              description: 'charge for appointment')
      rescue Stripe::StripeError # base error for Stripe
        charge_result = nil
      end
      @tracker.call(charge_result)
    end
  end
end
