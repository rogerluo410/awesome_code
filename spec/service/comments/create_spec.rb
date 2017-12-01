RSpec.describe Comments::Create do
  before do
    travel_to "2016-5-24 10:00".in_time_zone('Australia/Sydney')
  end

  let(:patient) {create(:patient)}
  let(:patient1) {create(:patient )}
  let(:doctor) {create(:doctor)}
  let(:appointment_setting) { create(:appointment_setting, doctor: doctor, start_time: "07:00", end_time: "13:00", week_day: "tuesday") }
  let(:appointment_product) { create(:appointment_product, doctor: doctor, start_time: Time.parse("2016-5-24 7:00 +10"), end_time: Time.parse("2016-5-24 13:00 +10"), appointment_setting: appointment_setting) }
  let(:appointment) { create(:appointment, patient: patient, doctor: doctor, appointment_product: appointment_product, status: :finished) }
  let(:appointment1) { create(:appointment, patient: patient1, doctor: doctor, appointment_product: appointment_product, status: :finished) }

  let(:valid_params) {
    {
      appointment_id: appointment.id,
      body: 'hi',
    }
  }

  context "with valid params" do
    context 'patient' do
      it 'create comment successfully' do
        service = described_class.call(patient, valid_params)

        expect(service).to be_success

        expect(service.result.appointment_id).to eq(appointment.id)
        expect(service.result.sender_id).to eq(patient.id)
        expect(service.result.receiver_id).to eq(doctor.id)
        expect(service.result.body).to eq('hi')
      end
    end

    context 'doctor' do
      it 'create comment successfully' do
        service = described_class.call(doctor, valid_params)

        expect(service).to be_success

        expect(service.result.appointment_id).to eq(appointment.id)
        expect(service.result.sender_id).to eq(doctor.id)
        expect(service.result.receiver_id).to eq(patient.id)
        expect(service.result.body).to eq('hi')
      end
    end
  end

  context "with invalid params" do
    it 'faild with appointment_id blank' do
      service = described_class.call(patient, valid_params.merge(appointment_id: nil))

      expect(service).to be_failure
      expect(service.error).to eq "appointment_id must not be blank"
    end

    it 'faild with body blank' do
      service = described_class.call(patient, valid_params.merge(body: nil))

      expect(service).to be_failure
      expect(service.error).to eq "body not be blank."
    end

    it 'faild with invalid appointment id' do
      service = described_class.call(patient, valid_params.merge(appointment_id: appointment1))

      expect(service).to be_failure
      expect(service.error).to eq "#{patient.name} Can not have this appointment."
    end
  end
end
