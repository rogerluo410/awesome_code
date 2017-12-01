RSpec.describe PushSmsNotification do
  let(:patient) { create(:patient) }
  let(:doctor) { create(:doctor) }
  let(:notification) { create(:notification, user_id: doctor.id, resource_id: patient.id, n_type: :normal) }

  before do
    twilio_client = double("Twilio::REST::Client")
    allow(twilio_client).to receive_message_chain('account.messages.create')
    allow(Twilio::REST::Client).to receive(:new).and_return(twilio_client)
  end

  describe 'method excute correctly' do
    it 'call succcess' do
      service = PushSmsNotification.call(notification)

      expect(service.success?).to eq(true)
      expect(service.errors.messages).to eq({})
      expect(service.notification).to eq(notification)
    end
  end
end
