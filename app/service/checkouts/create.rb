module Checkouts
  class Create
    include Serviceable

    attr_reader :customer

    def initialize(patient, card_params)
      @patient = patient
      @card_params = card_params
    end

    def call
      @card_params = validate_schema!(Schema, card_params)
      create_stripe_customer
      create_checkout
    end

    private

    attr_reader :patient, :card_params, :checkout

    # Create Stripe customer, see below for all errors
    # https://stripe.com/docs/api/ruby#errors
    def create_stripe_customer
      @customer = Stripe::Customer.create(
        source: card_params.merge(object: 'card')
      )
    rescue Stripe::CardError => e
      fail! e.message
    rescue Stripe::APIConnectionError, Stripe::APIError
      fail! "Temporary problem with saving your payment information, please try again."
    end

    def create_checkout
      card = customer.sources[:data][0]
      @checkout = Checkout.create!(
        patient: patient,
        default: !patient.checkouts.exists?,
        stripe_customer_id: customer.id,
        card_last4: card[:last4],
        brand: card[:brand],
        exp_month: card[:exp_month],
        exp_year: card[:exp_year],
        country: card[:country],
        funding: card[:funding],
      )
    end
  end
end
