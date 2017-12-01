RSpec.describe "Patient pharmacy API" do

  before :each do
    @pharmacies_with_email = FactoryGirl.create_list(:pharmacy_with_email, 5)
    @pharmacies_without_email = FactoryGirl.create_list(:pharmacy, 2)
    Pharmacy.import
    Pharmacy.__elasticsearch__.refresh_index!
  end

  describe "GET /v1/p/pharmacies" do
    subject {
      get '/v1/p/pharmacies', headers: token_headers(patient), params: {  street: 'origin', zip_code: '' }
    }

    let!(:patient) { FactoryGirl.create(:patient) }

    context "Total of Pharmacy is seven, five of them have email, rest of them do not." do
      it "gets a pharmacy list exclude the pharmacies which don't have email." do
        subject
        expect(response).to have_http_status(200)
        expect(json['data'].size).to be 5
      end
    end
  end
end
