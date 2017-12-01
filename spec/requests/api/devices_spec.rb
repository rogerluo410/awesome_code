RSpec.describe 'post with devices token' do
  let(:patient) { create :patient }
  let(:patient2) { create :patient, email: 'patient2@example.com' }
  let(:device) {
    create(:device,
      user_id: patient.id,
      token: '6d9d3d1d4df9affee91580d8d9199536123',
      platform: 'ios',
    )
  }
  let(:params) {
    {
      token: '6d9d3d1d4df9affee91580d8d9199536123',
      platform: 'ios'
    }
  }

  describe "POST /v1/devices" do
    it "responds 200" do
      post '/v1/devices', headers: token_headers(patient), params: params
      expect(response).to have_http_status(204)
      expect(response.body).to eq("")
    end

    it "responds 422" do
      post '/v1/devices', headers: token_headers(patient2), params: { platform: 'wrong' }
      expect(response).to have_http_status(422)
      expect(response).to match_api_schema(:error)
      expect(json['error']['message']).to eq("Platform is invalid")
    end
  end

  describe "DELETE /v1/devices" do
    it "responds 200" do
      device
      delete '/v1/devices', headers: token_headers(patient), params: params
      expect(response).to have_http_status(204)
      expect(response.body).to eq("")
    end
  end
end
