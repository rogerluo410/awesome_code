RSpec.describe Doctor, type: :model do
  let(:doctor) { FactoryGirl.create(:doctor, local_timezone: "Australia/Sydney") }

  describe 'public class methods' do
    context 'responds to its methods' do
      it { expect(Doctor).to respond_to(:week_days) }
    end
  end

  describe 'public instance method' do
    context 'responds to instance method' do
      it { expect(doctor).to respond_to(:get_appointment_settings_by_week_day).with(1) }
      it { expect(doctor).to respond_to(:is_available_now) }
      it { expect(doctor).to respond_to(:plans_in_current_weekday) }
      it { expect(doctor).to respond_to(:time_now_hour_minute) }
      it { expect(doctor).to respond_to(:as_indexed_json) }
    end

    context 'excute correctly' do
      context '#get_available_times_by_week_day' do
        it 'shoul return nil when the data is nil' do
          appointment_settings = double
          allow(doctor).to receive(:appointment_settings).and_return(appointment_settings)
          allow(appointment_settings).to receive(:with_week_day).with('tuesday').and_return([])

          results = doctor.get_appointment_settings_by_week_day('tuesday')

          expect(results).to eq([])
        end

        it 'should return doctor object' do
          appointment_settings = double
          allow(doctor).to receive(:appointment_settings).and_return(appointment_settings)
          allow(appointment_settings).to receive(:with_week_day).with('tuesday').and_return(doctor)

          results = doctor.get_appointment_settings_by_week_day('tuesday')

          expect(results).to eq(doctor)
        end
      end

      context '#is_available_now?' do
        it 'current time not in this period' do
          #TODO
        end

        it 'none people appointment' do
          #TODO
        end

        it 'people has appointmented all conlustation' do
          #TODO
        end
      end

      context '#time_now_hour_minute' do
        it 'return minutes and seoncds' do
          allow(Time).to receive(:current).and_return(Time.parse('2016-05-24 08:09:00 +10'))

          results = doctor.time_now_hour_minute

          expect(results).to eq('08:09')
        end

        it 'return minutes and seoncds' do
          allow(Time).to receive(:current).and_return(Time.parse('2016-05-24 00:10:00 +10'))

          results = doctor.time_now_hour_minute

          expect(results).to eq('00:10')
        end
      end

      context '#as_indexed_json' do
       #TODO
      end
    end
  end
end
