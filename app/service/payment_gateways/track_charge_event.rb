module PaymentGateways
  class TrackChargeEvent
    attr_reader :checkout, :amount, :appointment

    def initialize(options)
      @checkout = options[:checkout]
      @amount = options[:amount]
      @appointment = options[:appointment]
    end

    def call(charge_result)
      if charge_result.present?
        ChargeEventLog.create!(stripe_charge_id: charge_result.id,
                               stripe_customer_id: @checkout.stripe_customer_id,
                               checkout_id: @checkout.id,
                               charge_event: @appointment.charge_event,
                               amount: @amount/100,
                               currency: 'aud',
                               status: ChargeEventLog::STATUS_HASH[charge_result.status.to_sym],
                               card_last4: charge_result.source[:last4],
                               card_brand: charge_result.source[:brand],
                               )
      else
        ChargeEventLog.create!(stripe_charge_id: "",
                               stripe_customer_id: @checkout.stripe_customer_id,
                               checkout_id: @checkout.id,
                               charge_event: @appointment.charge_event,
                               amount: @amount/100,
                               currency: 'aud',
                               status: ChargeEventLog::STATUS_HASH[:failed],
                               card_last4: @checkout.card_last4,
                               card_brand: @checkout.brand,
                              )
      end
    end
  end
end
