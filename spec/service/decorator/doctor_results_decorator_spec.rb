describe 'Decorator::DoctorResultsDecorator' do
  let(:search_results) { [] }

  let(:from) { Time.utc(2016, 6, 20, 0, 0, 0).in_time_zone(10) }
  let(:to) { Time.utc(2016, 6, 20, 15, 0, 0).in_time_zone(10) }
  let(:page) { 0 }
  let(:doctor_results_decotator) { Decorator::DoctorResultsDecorator.new(search_results, page, from, to) }

  let(:doctor1) { create(:doctor, local_timezone: 'Australia/Sydney', email: 'testd1@example.com') }

  let(:appointment_setting1) { create(:appointment_setting, user_id: doctor1.id, start_time: '11:10',
                                        end_time: '12:10', week_day: 'tuesday') }
  let(:appointment_setting2) { create(:appointment_setting, user_id: doctor1.id, start_time: '13:10',
                                        end_time: '16:10', week_day: 'wensday') }
  class MyHash < Hash
    include Hashie::Extensions::MethodAccess
    include Hashie::Extensions::DeepMerge
  end

  describe 'public instance method' do
    describe 'responds to its methods' do
      it { expect(doctor_results_decotator).to respond_to(:call) }
    end
  end

  describe 'private instance method' do
    # keep time change correct
    describe '#from_time' do
      it 'retrun time with timezone' do
        doctor_start_time = Time.utc(2016, 6, 20, 15, 0, 0).in_time_zone(10)

        allow(from).to receive(:in_time_zone).with('Australia/Sydney')
          .and_return(doctor_start_time)

        results = doctor_results_decotator.send(:from_time, 'Australia/Sydney')

        expect(results).to eq(doctor_start_time)
      end
    end

    describe '#to_time' do
      it 'retrun time with timezone' do
        doctor_end_time = Time.utc(2016, 6, 20, 15, 0, 0).in_time_zone(10)

        allow(from).to receive(:in_time_zone).with('Australia/Sydney')
          .and_return(doctor_end_time)



        results = doctor_results_decotator.send(:to_time, 'Australia/Sydney')

        expect(results).to eq(doctor_end_time)
      end
    end

    describe '#from_time_weekday' do
      it 'return from_time week_day' do
        allow(doctor_results_decotator).to receive(:from_time).with(doctor1.local_timezone).and_return(Time.utc(2016, 6, 21, 0, 0, 0).in_time_zone(0))

        results = doctor_results_decotator.send(:from_time_weekday, doctor1.local_timezone)

        expect(results).to eq('tuesday')
      end
    end

    describe '#to_time_weekday' do
      it 'retrun to_time week_day' do
        allow(doctor_results_decotator).to receive(:to_time).with(doctor1.local_timezone).and_return(Time.utc(2016, 6, 21, 0, 0, 0).in_time_zone(0))

        results = doctor_results_decotator.send(:to_time_weekday, doctor1.local_timezone)

        expect(results).to eq('tuesday')
      end
    end

    describe '#is_available_now?' do
      it 'return is_available_now' do
        doctor = MyHash[
          is_available_now: false,
          id: 1
        ]

        dynamic_available = MyHash[
          is_available_now: true
        ]

        allow(Doctor).to receive(:find).with(doctor.id).and_return(dynamic_available)

        results = doctor_results_decotator.send(:is_available_now?, doctor)

        expect(results).to eq(true)
      end
    end

    describe '#current_time_available_slots' do
      it 'return avaliable_slots' do
        travel_to Time.parse("2016-6-20 11:25 +10")

        appointment_setting1

        allow(AppointmentSetting).to receive(:find).with(appointment_setting1.id).and_return(appointment_setting1)
        doctor_results_decotator.send(:appointment_setting_time_decorator, doctor1.local_timezone, appointment_setting1)
        results = doctor_results_decotator.send(:current_time_available_slots, appointment_setting1)

        expect(results).to eq(5)
      end
    end

    describe '#appointment_setting_time_decorator' do
      context 'when to_time_weekday and from_time_weekday in same day' do
        before do
          allow(doctor_results_decotator).to receive(:to_time_weekday).with(doctor1.local_timezone).and_return('tuesday')
          allow(doctor_results_decotator).to receive(:from_time_weekday).with(doctor1.local_timezone).and_return('tuesday')

          allow(doctor_results_decotator).to receive(:from_time).with(doctor1.local_timezone).and_return(Time.utc(2016, 6, 21, 0, 0, 0).in_time_zone(10))
          allow(doctor_results_decotator).to receive(:to_time).with(doctor1.local_timezone).and_return(Time.utc(2016, 6, 21, 0, 0, 0).in_time_zone(8))
        end

        it 'change appointment_setting start_time end_time to UTC time' do
          appointment_setting1
          doctor1.reload

          results = doctor_results_decotator.send(:appointment_setting_time_decorator,
                            appointment_setting1.doctor.local_timezone, appointment_setting1)


          expect(appointment_setting1.start_time.to_s).to eq('2016-06-21 11:10:00 +1000')
          expect(appointment_setting1.end_time.to_s).to eq('2016-06-21 12:10:00 +1000')
        end
      end

      context 'when to_time_weekday and from_time_weekday in different day but to_time_weekday eq time_weekday' do
        before do
          allow(doctor_results_decotator).to receive(:from_time_weekday).with(doctor1.local_timezone).and_return('wensday')
          allow(doctor_results_decotator).to receive(:to_time_weekday).with(doctor1.local_timezone).and_return('tuesday')

          allow(doctor_results_decotator).to receive(:from_time).with(doctor1.local_timezone).and_return(Time.utc(2016, 6, 21, 0, 0, 0).in_time_zone(10))
          allow(doctor_results_decotator).to receive(:to_time).with(doctor1.local_timezone).and_return(Time.utc(2016, 6, 22, 0, 0, 0).in_time_zone(10))
        end

        it 'change appointment_setting start_time end_time to UTC time' do
          appointment_setting1
          doctor1.reload

          results = doctor_results_decotator.send(:appointment_setting_time_decorator,
                            appointment_setting1.doctor.local_timezone, appointment_setting1)


          expect(appointment_setting1.start_time.to_s).to eq('2016-06-22 11:10:00 +1000')
          expect(appointment_setting1.end_time.to_s).to eq('2016-06-22 12:10:00 +1000')
        end
      end

      context 'when to_time_weekday and from_time_weekday in different day but from_time_weekday eq time_weekday' do
        before do
          allow(doctor_results_decotator).to receive(:from_time_weekday).with(doctor1.local_timezone).and_return('wensday')
          allow(doctor_results_decotator).to receive(:to_time_weekday).with(doctor1.local_timezone).and_return('tuesday')

          allow(doctor_results_decotator).to receive(:from_time).with(doctor1.local_timezone).and_return(Time.utc(2016, 6, 21, 0, 0, 0).in_time_zone(10))
          allow(doctor_results_decotator).to receive(:to_time).with(doctor1.local_timezone).and_return(Time.utc(2016, 6, 22, 0, 0, 0).in_time_zone(8))
        end

        it 'change appointment_setting start_time end_time to UTC time' do
          appointment_setting2
          doctor1.reload

          results = doctor_results_decotator.send(:appointment_setting_time_decorator,
                            appointment_setting1.doctor.local_timezone, appointment_setting2)


          expect(appointment_setting2.start_time.to_s).to eq('2016-06-21 13:10:00 +1000')
          expect(appointment_setting2.end_time.to_s).to eq('2016-06-21 16:10:00 +1000')
        end
      end
    end

    describe '#decorator_doctors' do
      it 'change doctors properties' do
          appointment_setting = MyHash[
             { start_time: '11:10',
               end_time: '12:10',
               week_day: 'tuesday'
             }
          ]

          decorator_setting = MyHash[
             { start_time: Time.utc(2016, 6, 11, 0, 0, 0).in_time_zone(8),
               end_time: Time.utc(2016, 6, 12, 0, 0, 0).in_time_zone(8),
               week_day: 'thursday',
               available_slots: 1
             }
          ]

          doctor = MyHash[
            {
              id: 1,
              approved: true,
              appointment_settings: [appointment_setting],
              local_timezone: 'Australia/Sydney',
              time_zone_to_offset: 8
            }
          ]

          doctors = [doctor]

          allow(doctor_results_decotator).to receive(:is_available_now?).and_return(true)
          allow(doctor_results_decotator).to receive(:decorator_appointment_settings).and_return([decorator_setting])
          allow(Doctor).to receive(:find).with(1).and_return(nil)

          results = doctor_results_decotator.send(:decorator_doctors, doctors)

          expect(results).to eq([{:id=>1,
              "is_available_now"=>true,
              "appointment_periods"=>
                [{:start_time=>Time.utc(2016, 6, 11, 0, 0, 0).in_time_zone(8),
                  :end_time=>Time.utc(2016, 6, 12, 0, 0, 0).in_time_zone(8),
                  :week_day=>"thursday",
                  :available_slots=>1}],
                  "total_available_slots"=>1,
                  "avatar_url"=>nil}])
      end
    end

    describe '#decorator_appointment_settings' do
      context 'when week_day not match' do
        it 'return null arrary' do
          appointment_setting = MyHash[
             { start_time: '11:10',
               end_time: '12:10',
               week_day: 'tuesday'
             }
          ]
          doctor = MyHash[
            {
              local_timezone: 'Australia/Sydney',
              appointment_settings: [appointment_setting]
            }
          ]
          allow(doctor_results_decotator).to receive(:from_time_weekday).with(doctor.local_timezone).and_return('thursday')
          allow(doctor_results_decotator).to receive(:to_time_weekday).with(doctor.local_timezone).and_return('thursday')
          allow(doctor_results_decotator).to receive(:current_time_available_slots).with(appointment_setting).and_return(true)
          allow(doctor_results_decotator).to receive(:appointment_setting_time_decorator).and_return(true)

          results = doctor_results_decotator.send(:decorator_appointment_settings, doctor.local_timezone, doctor.appointment_settings)

          expect(results).to eq([])
        end
      end

      context 'when week_day match' do
        it 'return appointment_setting' do
          appointment_setting = MyHash[
             { start_time: Time.utc(2016, 6, 11, 0, 0, 0).in_time_zone(8),
               end_time: Time.utc(2016, 6, 12, 0, 0, 0).in_time_zone(8),
               week_day: 'thursday'
             }
          ]
          doctor = MyHash[
            {
              local_timezone: 'Australia/Sydney',
              appointment_settings: [appointment_setting]
            }
          ]
          allow(doctor_results_decotator).to receive(:from_time_weekday).with(doctor.local_timezone).and_return('thursday')
          allow(doctor_results_decotator).to receive(:to_time_weekday).with(doctor.local_timezone).and_return('thursday')
          allow(doctor_results_decotator).to receive(:current_time_available_slots).with(appointment_setting).and_return(true)
          allow(doctor_results_decotator).to receive(:appointment_setting_time_decorator).with(doctor.local_timezone, appointment_setting).and_return(true)
          allow(doctor_results_decotator).to receive(:from_time).with(doctor.local_timezone).and_return(Time.utc(2016, 6, 10, 0, 0, 0).in_time_zone(8))
          allow(doctor_results_decotator).to receive(:to_time).with(doctor.local_timezone).and_return(Time.utc(2016, 6, 22, 0, 0, 0).in_time_zone(8))

          results = doctor_results_decotator.send(:decorator_appointment_settings, doctor.local_timezone, doctor.appointment_settings)
          expect(results).to eq([appointment_setting])
        end
      end
    end
  end
end