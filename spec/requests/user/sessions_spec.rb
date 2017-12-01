RSpec.describe 'User login request' do
  describe 'POST /users/sign_in' do
    let(:user) { create(:patient) }
    let(:params) { {data: {email: user.email, password: user.password}} }

    subject { post '/users/sign_in', params: params }

    context 'sign in via server render web pages' do
      it 'succeeds with valid params' do
        subject
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('text/html')
      end
    end

    context 'sign in via ajax' do
      before :each do
        params[:format] = :json
      end

      it 'succeeds with valid email and password' do
        subject
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json')
        expect(response).to match_api_schema(:session_user)
      end

      it 'fails with blank email' do
        params[:data][:email] = ''
        subject
        expect(response).to have_http_status(401)
        expect(response.content_type).to eq('application/json')
        expect(json['error']['message']).to eq("Email can't be blank")
      end

      it 'fails with blank password' do
        params[:data][:password] = ''
        subject
        expect(response).to have_http_status(401)
        expect(response.content_type).to eq('application/json')
        expect(json['error']['message']).to eq("Password can't be blank")
      end

      it 'fails with invalid email' do
        params[:data][:email] = 'fake@email.com'
        subject
        expect(response).to have_http_status(401)
        expect(response.content_type).to eq('application/json')
        expect(json['error']['message']).to eq('Email is invalid.')
      end
      it 'fails with invalid password' do
        params[:data][:password] = 'fake_password'
        subject
        expect(response).to have_http_status(401)
        expect(response.content_type).to eq('application/json')
        expect(json['error']['message']).to eq('Password is invalid.')
      end
    end
  end
end
