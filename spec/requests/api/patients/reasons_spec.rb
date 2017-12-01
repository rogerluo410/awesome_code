RSpec.describe 'Patient reason in survey request', type: :request do
    let(:patient) { create :patient }

    describe 'GET /v1/p/reasons' do
    	subject { get "/v1/p/reasons", headers: token_headers(patient) }

       it "return reason list." do
         subject
         expect(response).to have_http_status(200)
	   expect(json['data'].size).to be  > 0
	 end
    end
end
