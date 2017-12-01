RSpec.describe Auth::Logout do

  let(:patient) { FactoryGirl.create(:patient) }
  let(:params) {
    {
      auth_token: patient.generate_auth_token,
    }
  }
  context 'with valid auth_token' do
    it 'destory successfully' do
      service = described_class.call(patient, params)

      expect(service).to be_success
    end
  end

  context 'with invalid auth_token' do
    it 'destory failed' do
      params[:auth_token] = 'xx'
      service = described_class.call(patient, params)

      expect(service).to be_failure
      expect(service.error).to eq('xx is not a valid auth token')
    end
  end
end
