RSpec.describe "Patient appointments pay API" do
  describe "PUT /v1/p/appointments/:id/pay" do
    let(:perth) { 'Australia/Perth' }
    let(:current_date) { '2016-07-01' }
    let(:current_time) { "#{current_date} #{start_time}".in_time_zone(perth) }
    let(:start_time) { '10:00' }
    let(:end_time) { '11:00' }

    before do
      travel_to current_time
    end

    after do
      travel_back
    end

    it "pays successfully" do
      mock_stripe

      doctor = FactoryGirl.create(:doctor, :with_bank_account, local_timezone: perth)
      patient = FactoryGirl.create(:patient, :with_checkout, local_timezone: perth)

      appointment_product = FactoryGirl.create(:appointment_product,
        :with_appointment_setting,
        doctor: doctor,
        start_time: "#{current_date} #{start_time}".in_time_zone(perth),
        end_time: "#{current_date} #{end_time}".in_time_zone(perth),
      )

      appointment = FactoryGirl.create(:appointment,
        :with_survey,
        doctor: doctor,
        patient: patient,
        appointment_product: appointment_product,
        consultation_fee: 30,
      )

      call_api(patient, appointment, { data: { checkout_id: patient.checkouts.first.id } })

      expect(response).to have_http_status(200)
      expect(response).to match_api_schema(:appointment, layout: :item)
      expect(json['data']['paid']).to be true
    end

    def call_api(patient, appointment, params)
      put "/v1/p/appointments/#{appointment.id}/pay", headers: token_headers(patient), params: params
    end

    def mock_stripe
      charge_result = double("Stripe::Charge",
        id: SecureRandom.hex,
        status: 'succeeded',
        source: { last4: '1111', brand: 'Visa' },
      )

      allow(Stripe::Charge).to(
        receive(:create)
          .with(any_args)
          .and_return(charge_result)
      )
    end
  end
end
