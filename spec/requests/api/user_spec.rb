RSpec.describe 'get user info API' do
  include AppointmentContexts

  describe 'get /v1/user' do
    let(:patient) { create(:patient) }

    context 'with token authentication' do
      it 'succeeds with valid token' do
        get '/v1/user', headers: token_headers(patient)

        expect(response).to have_http_status(200)
        expect(response).to match_api_schema(:session_user)
      end
      it 'fails with invalid token' do
        get '/v1/user', headers: {'Authorization': 'invalid-token'}

        expect(response).to have_http_status(401)
        expect(json['error']['message']).to eq('User unauthorized.')
      end
      it 'fails without token' do
        get '/v1/user'

        expect(response).to have_http_status(401)
        expect(json['error']['message']).to eq('User unauthorized.')
      end
    end

    context 'with session authentication' do
      it 'fails when user has not logged into web system' do
        get '/v1/user', headers: session_headers(patient)

        expect(response).to have_http_status(401)
        expect(json['error']['message']).to eq('User unauthorized.')
      end

      it 'succeeds when user has logged into web system' do
        sign_in patient

        get '/v1/user', headers: session_headers(patient)
        expect(response).to have_http_status(200)
        expect(response).to match_api_schema(:session_user)
      end
    end
  end

  describe 'put /v1/user/avatar' do
    subject {
      put "/v1/user/avatar",
      headers: headers,
      params: { image: {uri: image} },
      as: :json
    }

    context 'Upload a base64 encoded image file from Mobile side.' do
      let(:headers) { token_headers(patient1) }
      let(:image) {
        File.read("#{Rails.root}/spec/requests/api/base64_image_data.txt")
      }
      it 'get the new image\'s URL.' do
        subject
        expect(response).to have_http_status(200)

        expect(json["data"]["attributes"]["avatarUrl"]).to start_with("https://example.com/uploads/patient/#{patient1.id}")
      end
    end
  end

end
