RSpec.describe Devices::Unregister do
  let(:user) { create(:patient) }
  let(:params) { { platform: 'ios', token: 'aaa' } }
  let(:device) { create(:device, params.merge(user: user)) }

  it "unregisters the device" do
    device
    service = described_class.(user, params)
    expect(service).to be_success
    expect { device.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "succeeds when device not exist" do
    service = described_class.(user, params)
    expect(service).to be_success
  end
end
