RSpec.describe FcmMessage do
  it "default pending" do
    expect(FcmMessage.new).to be_pending
  end
end
