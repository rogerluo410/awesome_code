module Checkouts
  class Delete
    include Serviceable

    attr_reader :customer

    def initialize(checkout)
      @checkout = checkout
    end

    def call
      retrieve_stripe_customer
      delete_stripe_customer_and_checkout
      checkout
    end

    private

    attr_reader :checkout

    def retrieve_stripe_customer
      @customer = Stripe::Customer.retrieve(checkout.stripe_customer_id)
    rescue Stripe::APIConnectionError, Stripe::APIError, Stripe::InvalidRequestError => e
      fail! e.message
    end

    def delete_stripe_customer_and_checkout
      customer.delete unless customer.deleted?
      checkout.destroy!
    rescue Stripe::APIConnectionError, Stripe::APIError, Stripe::InvalidRequestError => e
      fail! e.message
    end
  end
end
