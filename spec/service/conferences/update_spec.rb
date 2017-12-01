RSpec.describe Conferences::Update do
  before do
    travel_to Time.parse('2016-5-24 07:30 +10')
  end

  let(:doctor) { create(:doctor) }
  let(:patient) { create(:patient) }
  let(:appointment_setting) { create(:appointment_setting, doctor: doctor, start_time: "07:00", end_time: "08:00", week_day: "tuesday") }
  let(:appointment_product) { create(:appointment_product, doctor: doctor, start_time: Time.parse("2016-5-24 7:00 +10"), end_time: Time.parse("2016-5-24 8:00 +10"), appointment_setting: appointment_setting) }
  let(:appointment) { create(:appointment, patient: patient, doctor: doctor, appointment_product: appointment_product, status: :processing) }

  let(:conference) { create(:conference, appointment: appointment) }
  let(:update_type) { 'time' }
  let(:twilio_id) { 'fake_twilio_id' }
  let(:time_type) { 'start_time' }
  let(:status) { :cancelled_by_doctor }
  let(:params) { {update_type: update_type, status: status, twilio_id: twilio_id, time_type: time_type} }

  subject { described_class.call(conference.id, params) }

  context 'When with valid params' do
    it 'can update conference start time successfully' do
      result = subject
      expect(result).to be_success
      conference.reload
      expect(conference.twillo_id).to eq(twilio_id)
    end

    it 'can update conference end time successfully' do
      params[:time_type] = 'end_time'
      result = subject
      expect(result).to be_success
      conference.reload
      expect(conference.twillo_id).to eq(twilio_id)
      expect(conference.status).to eq('success')
    end

    it 'can update conference status successfully' do
      params[:update_type] = 'status'
      result = subject
      expect(result).to be_success
      conference.reload
      expect(conference.status).to eq(status)
    end
  end

  context 'When with invalid params' do
    it 'Failed with blank update type' do
      params[:update_type] = nil
      result = subject
      expect(result).to be_failure
      expect(result.error).to eq('Update type can not be blank.')
    end

    it 'Failed with invalid update type' do
      params[:update_type] = 'InvalidType'
      result = subject
      expect(result).to be_failure
      expect(result.error).to eq('Update type is invalid, can only be time or status.')
    end

    it 'Failed with invalid update type' do
      params[:update_type] = 'InvalidType'
      result = subject
      expect(result).to be_failure
      expect(result.error).to eq('Update type is invalid, can only be time or status.')
    end

    it 'Failed with blank time type when update time' do
      params[:time_type] = ''
      result = subject
      expect(result).to be_failure
      expect(result.error).to eq('Time type can not be blank.')
    end

    it 'Failed with invalid time type when update time' do
      params[:time_type] = 'InvalidTimeType'
      result = subject
      expect(result).to be_failure
      expect(result.error).to eq('Time type is invalid, can only be start_time or end_time')
    end

    it 'Failed with blank twilio id when update time' do
      params[:twilio_id] = nil
      result = subject
      expect(result).to be_failure
      expect(result.error).to eq('Twilio id can not be blank')
    end

    it 'Failed with blank status when update status' do
      params[:status] = nil
      params[:update_type] = 'status'
      result = subject
      expect(result).to be_failure
      expect(result.error).to eq('Status can not be blank.')
    end

    it 'Failed with invalid conference id' do
      result = described_class.call(123, params)
      expect(result).to be_failure
      expect(result.error).to eq("Can not find conference with id 123")
    end

    it 'Failed when conference appointment is invalid' do
      conference.update(appointment_id: nil)
      result = subject
      expect(result).to be_failure
      expect(result.error).to eq("Can not find the appointment for conference with id #{conference.id}")
    end
  end
end
