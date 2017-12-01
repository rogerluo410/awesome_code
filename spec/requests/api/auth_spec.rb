RSpec.describe 'Auth API' do
  describe 'POST /v1/auth/login' do
    let(:user) { create(:patient) }

    subject { post '/v1/auth/login', params: params }

    context 'with valid params' do
      let(:params) { {data: {email: user.email, password: user.password, role: 'Patient'}} }

      it 'succeeds' do
        subject

        expect(response).to have_http_status(200)

        expect(response).to match_api_schema(:auth_user)
        expect(json['data']['auth_token']).to eq(user.auth_tokens.last.id)
      end
    end

    context 'with invalid params' do
      let(:params) { {data: {email: user.email, password: user.password, role: 'Patient'}} }

      it 'signs auth token with blank email' do
        params[:data][:email] = nil
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq('Email can not be blank.')
      end

      it 'signs auth token with blank password' do
        params[:data][:password] = nil
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq('Password can not be blank.')
      end

      it 'Signs auth token with invalid password and email' do
        params[:data][:password] = 'InvalidPassword'
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq('Invalid email or password.')
      end

      it 'Signs auth token for an unconfirmed user' do
        user.update(confirmed_at: nil)
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq('You have to confirm your email address before continuing.')
      end

      it 'Signs auth token for user with blank role' do
        params[:data][:role] = nil
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq('User role can not be blank.')
      end

      it 'Signs auth token for user with invalid role' do
        params[:data][:role] = 'Admin'
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq('Role admin is invalid.')
      end

      it 'Signs auth token for user with wrong role' do
        params[:data][:role] = 'Doctor'
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq('Please sign in as a patient.')
      end
    end
  end

  describe 'POST /v1/auth/register' do
    context 'when request from web' do
      let(:params) { {data: {email: ''}} }
      let(:patient) { create(:patient) }
      subject { post '/v1/auth/register', params: params, headers: {'X-Session-Auth': true} }

      it 'returns 422 when email is blank' do
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq("Email can't be blank")
      end

      it 'returns 422 when email already exists' do
        patient
        params[:data][:email] = patient.email
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq('This email has already registered, please login directly.')
      end

      it 'returns 200 with valid params' do
        params[:data][:email] = 'register_test@gmail.com'
        subject
        expect(response).to have_http_status(200)
        expect(response).to match_api_schema(:session_user)
      end
    end

    context 'when request from native client' do
      let(:params) { {data: {email: ''}} }
      let(:patient) { create(:patient) }
      subject { post '/v1/auth/register', params: params }

      it 'returns 422 when email is blank' do
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq("Email can't be blank")
      end

      it 'returns 422 when email already exists' do
        patient
        params[:data][:email] = patient.email
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq('This email has already registered, please login directly.')
      end

      it 'returns 200 with valid params' do
        params[:data][:email] = 'register_test@gmail.com'
        subject
        expect(response).to have_http_status(200)
        expect(response).to match_api_schema(:auth_user)
      end
    end
  end

  describe 'POST /v1/auth/logout' do
    let(:user) { create(:patient) }

    subject { post '/v1/auth/logout', params: params, headers: token_headers(user) }
    let(:params) {
      {data:
        { auth_token: user.generate_auth_token }
      }
    }

    context 'with valid params' do
      it 'destroy success' do
        subject
        expect(response).to have_http_status(204)
      end
    end

    context 'with invalid params' do
      it 'destroy fail' do
        params[:data][:auth_token] = 'xx'
        subject
        expect(json['error']['message']).to eq('xx is not a valid auth token')
      end
    end
  end

  describe 'POST /v1/auth/sign_up' do
    let(:user) { create(:patient) }

    subject { post '/v1/auth/sign_up', params: params }
    let(:params) {
      {
        data: {
          role: 'Patient', email: 'new_email@test.com', password: 'password', phone: '12345678', first_name: 'FirstName', last_name: 'LastName'
        }
      }
    }
    context 'when with valid params' do
      it 'succeeds' do
        subject
        expect(response).to have_http_status(200)
        expect(json['message']).to eq('A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.')
      end
    end

    context 'when with invalid params' do
      it 'returns 422 when role is blank' do
        params[:data][:role] = nil
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq('User role can not be blank.')
      end

      it 'returns 422 when role is not patient or doctor' do
        params[:data][:role] = 'Admin'
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq('User role can only be patient or doctor.')
      end

      it 'returns 422 when email is blank' do
        params[:data][:email] = nil
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq('Email can not be blank.')
      end

      it 'returns 422 when email already exists' do
        params[:data][:email] = user.email
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq('This email has already registered, please login directly.')
      end

      it 'returns 422 when password is blank' do
        params[:data][:password] = nil
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq('Password can not be blank.')
      end

      it 'returns 422 when password is too short' do
        params[:data][:password] = '123'
        subject
        expect(response).to have_http_status(422)
        expect(json['error']['message']).to eq('Password is too short (minimum is 6 characters)')
      end
    end
  end

  describe 'GET /v1/auth/check' do
    let(:user) { FactoryGirl.create(:patient) }
    let(:token) { FactoryGirl.create(:auth_token, user: user) }
    subject { get '/v1/auth/check', params: params }
    let(:params) {
      {
        token: token.id
      }
    }
    context 'when with valid token.' do
      it "Successful." do
        subject

        expect(response).to have_http_status(200)
        expect(response).to match_api_schema(:auth_user)
      end
    end
  end

end
