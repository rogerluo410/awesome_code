class AppointmentTransfersJob < ApplicationJob
  queue_as :default

  def perform(appointment)
    ::AppointmentTransfers::CreateTransferCore.call(appointment)
  end
end
