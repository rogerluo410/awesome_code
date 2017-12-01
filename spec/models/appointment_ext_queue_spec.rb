RSpec.describe Appointment, type: :model do
  before do
    travel_to Time.parse("2016-5-24 10:00 +10")
  end

  let(:doctor) { FactoryGirl.create(:doctor, local_timezone: 'Australia/Sydney') }
  let(:patient1) { FactoryGirl.create(:patient, email: 'test1@example.com', local_timezone: 'Australia/Sydney') }
  let(:patient2) { FactoryGirl.create(:patient, email: 'test2@example.com', local_timezone: 'Australia/Sydney') }
  let(:patient3) { FactoryGirl.create(:patient, email: 'test3@example.com', local_timezone: 'Australia/Sydney') }

  let(:start_time) {Time.parse("2016-5-24 08:00 +10")}
  let(:end_time) {Time.parse("2016-5-24 17:00 +10")}
  let(:appointment_setting) { FactoryGirl.create(:appointment_setting, user_id: doctor.id, start_time: '08:00',
                                        end_time: '17:00', week_day: 'tuesday') }

  let(:appointment_product) {create(:appointment_product, doctor: doctor, appointment_setting: appointment_setting, start_time: start_time, end_time: end_time )}
  let(:appointment) { FactoryGirl.create(:appointment, doctor_id: doctor.id, patient_id: patient1.id,
                                          appointment_product: appointment_product) }

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(appointment).to respond_to(:in_queue?) }
      it { expect(appointment).to respond_to(:queue_before_me) }
      it { expect(appointment).to respond_to(:estimate_consult_time) }
      it { expect(appointment).to respond_to(:is_turn_to_consult?) }
    end

    context 'visit each instance methods' do
      let(:appointment1) { FactoryGirl.create(:appointment, doctor_id: doctor.id, patient_id: patient1.id,
                            appointment_product: appointment_product) }
      let(:appointment2) { FactoryGirl.create(:appointment, doctor_id: doctor.id, patient_id: patient2.id,
                            appointment_product: appointment_product, queue_no: 10003, status: 'accepted') }

      context 'when check instance method in_queue?' do

        it 'should return false when appointment is out of date' do
          #mock the appointment status to be accepted
          allow(appointment).to receive(:status_accepted?).and_return(true)
          #mock current time
          travel_to Time.parse("2016-5-25 10:00 +10")

          result = appointment.in_queue?

          expect(result).to eq(false)
        end

        it 'should return true when appointment end time is before current time' do
          #mock the appointment status to be accepted
          allow(appointment).to receive(:status_accepted?).and_return(true)
          #mock current time
          travel_to Time.parse("2016-5-24 18:00 +10")

          result = appointment.in_queue?

          expect(result).to eq(false)
        end

        it 'should be true when in the condition' do
          #mock the appointment status to be accepted
          allow(appointment).to receive(:status_accepted?).and_return(true)
          result = appointment.in_queue?
          expect(result).to eq(true)
        end
      end

      context 'when checke instance method queue_before_me' do
        it 'should be in queue return a number' do
          #mock the appointment in queue
          allow(appointment).to receive(:in_queue?).and_return(true)

          appointment_queue = double
          allow(appointment).to receive(:appointment_queue).and_return(appointment_queue)
          allow(appointment_queue).to receive(:queue_before_me).with(appointment.id).and_return(1)

          result = appointment.queue_before_me

          expect(result).to eq(1)
        end

        it 'should not be in queue' do
          allow(appointment).to receive(:in_queue?).and_return(false)

          result = appointment.queue_before_me

          expect(result).to eq('not in queue')
        end
      end

      context 'when check instance method estimate_consult_time' do
        before do
          #mock the appointment in queue
          allow(appointment).to receive(:in_queue?).and_return(true)
        end

        it 'should not be in queue' do
          #mock the appointment not in queue
          allow(appointment).to receive(:in_queue?).and_return(false)

          result = appointment.estimate_consult_time
          expect(result).to eq('Time out')
        end

        it 'should be current time when there is no patient before me' do
          result = appointment.estimate_consult_time

          expect(result).to eq('10:00')
        end

        it 'should be in half hour later when there are tow patient before me' do
          #mock the queue number
          allow(appointment).to receive(:queue_before_me).and_return(2)
          result = appointment.estimate_consult_time

          expect(result).to eq('10:24')
        end

        it 'should be start time of the period when appointment time in future' do
          double(:appointment_product)
          #mock the appointment product start time after current time
          allow(appointment_product).to receive(:start_time).and_return(Time.parse("2016-5-24 12:00 +10"))

          result = appointment.estimate_consult_time

          expect(result).to eq('12:00')
        end

        it 'should be the calculated value when some body before me' do
          #mock the appointment product start time after current time
          allow(appointment_product).to receive(:start_time).and_return(Time.parse("2016-5-24 12:00 +10"))
          allow(appointment).to receive(:queue_before_me).and_return(2)

          result = appointment.estimate_consult_time

          expect(result).to eq('12:24')
        end
      end

      context 'when check instance method is_turn_to_consult' do
        before do

          allow(appointment_product).to receive(:start_time).and_return(Time.parse("2016-5-24 10:00 +10"))
          allow(appointment_product).to receive(:end_time).and_return(Time.parse("2016-5-24 14:00 +10"))


          appointment_queue = double

          allow(appointment).to receive(:appointment_queue).and_return(appointment_queue)
          allow(appointment).to receive(:status).and_return('accepted')
          allow(appointment_queue).to receive(:will_pop_element).and_return(appointment.id)
        end

        it 'should return false when start time is not rechieved' do
          allow(appointment_product).to receive(:start_time).and_return(Time.parse("2016-5-24 13:00 +10"))

          result = appointment.is_turn_to_consult?

          expect(result).to eq('It is not time to start.')
        end

        it 'should return false when end time is passed' do
          allow(appointment_product).to receive(:start_time).and_return(Time.parse("2016-5-24 09:00 +10"))
          allow(appointment_product).to receive(:end_time).and_return(Time.parse("2016-5-24 10:00 +10"))

          result = appointment.is_turn_to_consult?

          expect(result).to eq('The appointment is time out.')
        end

        it 'should return true when in the condition' do
          result = appointment.is_turn_to_consult?
          expect(result).to eq(nil)
        end
      end
    end
  end
end
