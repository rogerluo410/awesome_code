RSpec.describe Notification do
  before do
    stub_callbacks
  end

  describe '#create_fcm_message' do
    subject { notification.create_fcm_message }

    let(:notification) { create(:notification, user: user) }
    let(:user) { create(:patient) }

    before do
      stub_set_notification_attr
    end

    it 'skips creating fcm message when tokens are blank' do
      expect(subject).to be_nil
    end

    it 'creates fcm message' do
      user.devices = [create(:device, token: 'aaa')]

      expect(notification).to receive(:title).and_return('Test title')
      expect(notification).to receive(:body).and_return('Test body')

      fcm_message = subject
      expect(fcm_message).to be_persisted
      expect(fcm_message.tokens).to eq(['aaa'])
      expect(fcm_message.notification).to eq(
        'title' => 'Test title',
        'body' => 'Test body',
        'badge' => 1,
      )
      expect(fcm_message.web_notification).to eq(notification)
    end
  end

  def stub_callbacks
    allow_any_instance_of(Notification).to receive(:realtime_push_to_client)
  end

  def stub_set_notification_attr
    allow_any_instance_of(Notification).to receive(:set_notification_attr)
  end
end
