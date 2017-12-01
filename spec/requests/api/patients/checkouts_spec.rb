RSpec.describe "Patient checkouts API" do
  describe "GET /v1/p/checkouts" do
    subject { get '/v1/p/checkouts', headers: token_headers(patient) }

    let!(:patient) { FactoryGirl.create(:patient) }
    let!(:checkout1) { FactoryGirl.create(:checkout, patient: patient) }
    let!(:checkout2) { FactoryGirl.create(:checkout, patient: patient) }

    it "gets a list of checkouts" do
      subject
      expect(response).to have_http_status(200)
      expect(response).to match_api_schema(:checkout, layout: :list)
      expect(json['data'].size).to be 2
    end

    it "sorts checkouts by id desc" do
      subject
      expect(json['data'][0]['id']).to eq(checkout2.id)
      expect(json['data'][1]['id']).to eq(checkout1.id)
    end
  end

  describe "POST /v1/p/checkouts" do
    subject { post '/v1/p/checkouts', params: params, headers: headers, as: :json }

    let(:headers) { token_headers(patient) }
    let(:patient) { FactoryGirl.create(:patient) }

    before { mock_stripe_customer }

    context "when success" do
      let!(:params) { { number: '4242424242424242', exp_month: 12, exp_year: 2020, cvc: '123' } }

      it "responds 201" do
        subject
        expect(response).to have_http_status(201)
        expect(response).to match_api_schema(:checkout, layout: :item)
      end
    end

    context "when fail" do
      let!(:params) { { invalid: true } }

      it "responds 422" do
        subject
        expect(response).to have_http_status(422)
        expect(response).to match_api_schema(:error)
      end
    end

    def mock_stripe_customer
      customer = double("Stripe::Customer",
        id: SecureRandom.hex,
        sources: {
          data: [{
            last4: '1111',
            brand: 'Visa',
            exp_month: 12,
            exp_year: 17,
            country: 'US',
            funding: 'credit',
          }]
        }
      )

      allow(Stripe::Customer).to(
        receive(:create)
          .with(any_args)
          .and_return(customer)
      )
    end
  end

  describe "PUT /v1/checkouts/:id/set_default" do
    subject { put "/v1/p/checkouts/#{checkout_id}/set_default", headers: headers, as: :json }

    let(:headers) { token_headers(patient) }
    let(:patient) { FactoryGirl.create(:patient) }

    context "when checkout not found for current user" do
      let(:checkout_id) { FactoryGirl.create(:checkout).id }

      it "responds 404" do
        subject
        expect(response).to have_http_status(404)
        expect(response).to match_api_schema(:error)
      end
    end

    context "when checkout exists" do
      let!(:checkout1) { FactoryGirl.create(:checkout, patient: patient, default: false) }
      let!(:checkout2) { FactoryGirl.create(:checkout, patient: patient, default: true) }
      let(:checkout_id) { checkout1.id }

      it "responds 200" do
        subject

        expect(response).to have_http_status(200)
        expect(response).to match_api_schema(:checkout, layout: :item)

        checkout1.reload
        checkout2.reload
        expect(checkout1).to be_default
        expect(checkout2).not_to be_default
      end
    end
  end

  describe "DELETE /v1/checkouts/:id" do
    subject { delete "/v1/p/checkouts/#{checkout.id}", headers: headers, as: :json }

    let(:headers) { token_headers(patient) }
    let(:patient) { FactoryGirl.create(:patient) }
    let(:checkout) { FactoryGirl.create(:checkout, patient: patient) }

    context "when success" do
      it "responds 204" do
        customer = double(Stripe::Customer, delete: nil, deleted?: false)

        expect(Stripe::Customer).to(
          receive(:retrieve)
            .with(checkout.stripe_customer_id)
            .and_return(customer)
        )

        subject
        expect(response).to have_http_status(204)
        expect(response.body).to be_blank
      end
    end

    context "when fail" do
      it "responds 422" do
        stripe_error = "Fake stripe error"
        expect(Stripe::Customer).to(
          receive(:retrieve)
            .with(checkout.stripe_customer_id)
            .and_raise(Stripe::InvalidRequestError.new(stripe_error, nil))
        )

        subject
        expect(response).to have_http_status(422)
        expect(response).to match_api_schema(:error)
        expect(json['error']['message']).to eq stripe_error
      end
    end
  end
end
