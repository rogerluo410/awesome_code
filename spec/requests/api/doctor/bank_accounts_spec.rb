RSpec.describe "doctor bank account apis" do
  include AppointmentContexts

  let(:headers) { token_headers(doctor1) }

  describe "GET /doctor/bank_account" do
    subject {
      get "/v1/d/bank_account",
      headers: headers,
      as: :json
    }

    context "When a doctor has a bank account." do
      it "get bank account info." do
        subject
        expect(response).to have_http_status(200)
        expect(response).to match_api_schema(:bank_account)
        expect(BankAccount.where(doctor: doctor1).count).to eq(1)
      end
    end
  end

  describe "POST /doctor/bank_account" do
    let(:params){
      {
        number: "000123456789", currency: "aud", country: "Australia"
      }
    }
    subject {
      post "/v1/d/bank_account",
      params: params,
      headers: headers,
      as: :json
    }

    context "When a doctor creates bank account." do
      it "create successfully." do
        subject
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE /doctor/bank_account" do
    subject {
      delete "/v1/d/bank_account",
      headers: headers,
      as: :json
    }
    context "When a doctor destroys bank account." do
      it "destroy successfully." do
        subject
        expect(response).to have_http_status(200)
        expect(BankAccount.where(doctor: doctor1).count).to eq(0)
      end
    end
  end

end
