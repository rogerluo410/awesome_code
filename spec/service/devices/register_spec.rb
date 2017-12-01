RSpec.describe Devices::Register do
  let(:patient) { create(:patient) }
  let(:params) {
    {
      platform: 'ios',
      token: 'fuaEO8Cg1QY:APA91bFIXaoKa0mwbygh0Lgnx8cJhllhOgx1XCsKgatf3DPCj6ugmQXGfPV4Wk30pGzrWAge8on6EaBBGT2pZuf4ciVdYzov693A7yoJ0PRfHPfweI-M5aZizHxNSt7nHRQL0lNzDJnL',
    }
  }

  subject { described_class.(patient, params) }

  it "fails for nil token" do
    params[:token] = nil

    expect(subject).not_to be_success
    expect(subject.error).to eq("Token can't be blank")
  end

  it "fails for invalid platform" do
    params[:platform] = 'wrong'

    expect(subject).not_to be_success
    expect(subject.error).to eq("Platform is invalid")
  end

  it "creates a new device when not registered" do
    expect(Device.count).to eq(0)
    expect(subject).to be_success

    device = subject.result
    expect(device).to be_persisted
    expect(device.platform).to eq(params[:platform])
    expect(device.token).to eq(params[:token])
    expect(device.user).to eq(patient)
  end

  it "updates the device when exists" do
    device = create(:device, platform: params[:platform], token: params[:token], user: create(:patient))

    expect(subject).to be_success

    new_device = subject.result
    device.reload
    expect(new_device).to eq(device)
    expect(new_device.user).to eq(patient)
  end
end
