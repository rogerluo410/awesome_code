RSpec.describe User do
  describe ".calc_uniq_username" do
    it "returns basename if it can be used" do
      expect(User.calc_uniq_username('david')).to eq('david')
    end

    it "returns basename + num if basename is used" do
      create(:user, username: 'david')
      create(:user, username: 'david1')
      expect(User.calc_uniq_username('david')).to eq('david2')
    end
  end

  describe "#init_username (before_create)" do
    it "creates a unique username based on email when created" do
      user = create(:user, email: 'david@example.com')
      expect(user.username).to eq('david')
    end
  end

  describe '#device_tokens' do
    it 'gets device tokens' do
      user = create(:user, devices: [
        create(:device, platform: 'ios', token: 'ios_token'),
        create(:device, platform: 'android', token: 'android_token'),
      ])

      expect(user.device_tokens).to eq(%w[ios_token android_token])
    end
  end

end
