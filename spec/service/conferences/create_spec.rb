RSpec.describe Conferences::Create do
  before do
    travel_to Time.parse('2016-5-24 07:30 +10')
  end

  let(:doctor) { create(:doctor) }
  let(:patient) { create(:patient) }
  let(:appointment_setting) { create(:appointment_setting, doctor: doctor, start_time: "07:00", end_time: "08:00", week_day: "tuesday") }
  let(:appointment_product) { create(:appointment_product, doctor: doctor, start_time: Time.parse("2016-5-24 7:00 +10"), end_time: Time.parse("2016-5-24 8:00 +10"), appointment_setting: appointment_setting) }
  let(:appointment) { create(:appointment, patient: patient, doctor: doctor, appointment_product: appointment_product) }
  let(:mock_response) { double }
  let(:mock_error) { 'Mock validation error.' }

  context 'When with valid params' do
    before do
      allow(Conferences::Validation).to receive(:call).and_return mock_response
      allow(mock_response).to receive(:success?).and_return true
      allow(mock_response).to receive(:appointment).and_return appointment

      allow(UpdateAppointmentStatus).to receive(:call).and_return mock_response
      allow(mock_response).to receive(:success?).and_return true
      allow(appointment).to receive(:status).and_return :processing
    end

    it 'create conference successfully' do
      conference_count = appointment.conferences.count
      result = described_class.call(doctor, appointment.id)
      expect(result).to be_success
      expect(appointment.conferences.count).to eq(conference_count+1)
      expect(appointment.status).to eq(:processing)
    end
  end

  context 'When appointment is invalid for creating conference' do
    before do
      allow(Conferences::Validation).to receive(:call).and_return mock_response
      allow(mock_response).to receive(:success?).and_return false
      allow(mock_response).to receive(:error).and_return mock_error
    end

    it 'create conference failed' do
      result = described_class.call(doctor, appointment.id)

      expect(result).to be_failure
      expect(appointment.conferences.count).to eq(0)
      expect(appointment.status).to eq(:pending)
    end
  end

  context 'When appointment status can not transfer to processing' do
    before do
      allow(Conferences::Validation).to receive(:call).and_return mock_response
      allow(mock_response).to receive(:success?).and_return true

      allow(UpdateAppointmentStatus).to receive(:call).and_return mock_response
      allow(mock_response).to receive(:success?).and_return false
      allow(mock_response).to receive(:error).and_return mock_error
    end

    it 'create conference failed' do
      result = described_class.call(doctor, appointment.id)

      expect(result).to be_failure
      expect(appointment.conferences.count).to eq(0)
      expect(appointment.status).to eq(:pending)
    end
  end
end
