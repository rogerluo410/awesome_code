module TransferGateways
  class TrackTransferEvent
    attr_reader :destination, :amount, :appointment

    def initialize(options)
      @amount = options[:amount]
      @appointment = options[:appointment]
      @destination = options[:destination]
    end

    def call(transfer_result, error_message)
      if transfer_result.present?
        TransferEventLog.create!(stripe_transfer_id: transfer_result.id,
                               transfer_event: @appointment.transfer_event,
                               amount: @amount/100,
                               currency: 'aud',
                               status: TransferEventLog::STATUS_HASH[transfer_result.status.to_sym],
                               destination: @destination
                               )
      else
        TransferEventLog.create!(stripe_transfer_id: "",
                               transfer_event: @appointment.transfer_event,
                               amount: @amount/100,
                               currency: 'aud',
                               status: TransferEventLog::STATUS_HASH[:failed],
                               destination: @destination,
                               error_message: error_message
                              )
      end
    end
  end
end
