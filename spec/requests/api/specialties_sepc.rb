RSpec.describe 'Api::V1::Specialty' do
  describe 'get /v1/me' do
    let(:specialty) { create(:specialty) }

    context 'get /v1/me' do
      it 'normal' do
        get '/v1/specialties'

        expect(response).to have_http_status(200)

        expect(response).to match_api_schema(:specialty, layout: :list)
      end
    end
  end
end