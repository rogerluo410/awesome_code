RSpec.describe 'push web notification' do
  let(:patient) { create(:patient) }
  let(:doctor) { create(:doctor) }
  let(:notification) { create(:notification, user_id: doctor.id, resource_id: patient.id, n_type: :normal) }

  describe 'method excute correctly' do
    it 'call succcess' do
      service = PushWebNotification.call(notification)

      expect(service.success?).to eq(true)
      expect(service.errors.messages).to eq({})
      expect(service.notification).to eq(notification)
    end
  end
end