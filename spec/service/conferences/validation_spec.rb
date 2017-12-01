RSpec.describe Conferences::Validation do
  before do
    travel_to Time.parse('2016-5-24 07:30 +10')
  end

  let(:admin) { create(:admin, email: 'admin@test.com') }
  let(:doctor) { create(:doctor) }
  let(:patient) { create(:patient) }
  let(:appointment_setting) { create(:appointment_setting, doctor: doctor, start_time: "07:00", end_time: "08:00", week_day: "tuesday") }
  let(:appointment_product) { create(:appointment_product, doctor: doctor, start_time: Time.parse("2016-5-24 7:00 +10"), end_time: Time.parse("2016-5-24 8:00 +10"), appointment_setting: appointment_setting) }
  let(:appointment) { create(:appointment, patient: patient, doctor: doctor, appointment_product: appointment_product, status: :accepted) }

  let(:appointment_setting1) { create(:appointment_setting, doctor: doctor, start_time: "08:30", end_time: "09:00", week_day: "tuesday") }
  let(:appointment_product1) { create(:appointment_product, doctor: doctor, start_time: Time.parse("2016-5-24 8:30 +10"), end_time: Time.parse("2016-5-24 9:00 +10"), appointment_setting: appointment_setting1) }
  let(:appointment1) { create(:appointment, patient: patient, doctor: doctor, appointment_product: appointment_product1, status: :accepted) }

  describe 'Call Conferences::Validation service' do
    context 'with valid params' do
      it 'Returns true with valid doctor and appointment' do
        service = described_class.call(doctor, appointment.id)
        expect(service).to be_success
        expect(service.result).to eq(true)
      end

      it 'Returns true with valid patient and appointment' do
        service = described_class.call(patient, appointment.id)
        expect(service).to be_success
        expect(service.result).to eq(true)
      end
    end

    context 'with invalid user or appointment id' do
      it 'Returns error when user is blank.' do
        service = described_class.call(nil, appointment.id)
        expect(service).to be_failure
        expect(service.error).to eq('User can not be blank.')
      end

      it 'Returns error when user is not patient nor doctor' do
        service = described_class.call(admin, appointment.id)
        expect(service).to be_failure
        expect(service.error).to eq('Only patient or doctor can join video call.')
      end

      it 'Returns error when appointment_id is blank' do
        service = described_class.call(doctor, nil)
        expect(service).to be_failure
        expect(service.error).to eq('Appointment id can not be blank.')
      end

      it 'Returns error when appointment does not exist' do
        service = described_class.call(doctor, 12345)
        expect(service).to be_failure
        expect(service.error).to eq('Can not find the appointment.')
      end

      it 'Returns error when appointment does not belong to user' do
        appointment.update(patient_id: 123)
        service = described_class.call(patient, appointment.id)
        expect(service).to be_failure
        expect(service.error).to eq('This appointment does not belong to you.')
      end
    end

    context 'with invalid appointment' do
      it 'Return error when current time is earlier than appointment estimation start time' do
        appointment_product.update(start_time: Time.parse('2016-5-24 7:40 +10'))
        service = described_class.call(patient, appointment.id)
        expect(service).to be_failure
        expect(service.error).to eq('It is not time to start.')
      end

      it 'Return error when appointment status is invalid' do
        appointment.update(status: :finished)
        service = described_class.call(patient, appointment.id)
        expect(service).to be_failure
        expect(service.error).to eq('You can not start, the appointment is finished.')
      end
    end
  end
end
