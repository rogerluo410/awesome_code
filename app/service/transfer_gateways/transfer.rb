module TransferGateways
  class Transfer
    include Serviceable

    attr_reader :destination

    def initialize(tracker)
      @tracker = tracker
      @destination = tracker.destination
      @amount = tracker.amount
    end

    def call
      error_message = nil
      transfer_result = nil

      begin
        transfer_result = Stripe::Transfer.create(amount: @amount.to_i,
                                              currency: 'aud',
                                              destination: destination,
                                              description: 'transfer for appointment')
      rescue Stripe::StripeError => error # base error for Stripe
        error_message = error.message
      end
      @tracker.call(transfer_result, error_message)
    end
  end
end
