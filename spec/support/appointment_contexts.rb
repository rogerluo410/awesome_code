module AppointmentContexts
  extend RSpec::SharedContext

  def create_time(time:, zone:, date: nil)
    date ||= today
    "#{date} #{time}".in_time_zone(zone)
  end

   before :each do
    # It's Tuesday
    travel_to create_time(time: '10:40', zone: perth)
  end

  let(:today) { '2016-05-24' }
  let(:perth) { 'Australia/Perth' } # +08:00
  let(:sydney) { 'Australia/Sydney' } # +10:00

  let(:doctor1) { FactoryGirl.create(:doctor, local_timezone: perth) }
  let(:doctor2) { FactoryGirl.create(:doctor, local_timezone: sydney) }

  let(:doctor1_setting1) {
    FactoryGirl.create(:appointment_setting,
      user_id: doctor1.id,
      start_time: '11:00',
      end_time: '12:00',
      week_day: 'tuesday'
    )
  }

 let(:doctor1_setting2) {
    FactoryGirl.create(:appointment_setting,
      user_id: doctor1.id,
      start_time: '10:00',
      end_time: '11:00',
      week_day: 'tuesday'
    )
  }

  let(:doctor1_setting3) {
    FactoryGirl.create(:appointment_setting,
      user_id: doctor1.id,
      start_time: '09:00',
      end_time: '10:00',
      week_day: 'wednesday'
    )
  }

  let(:doctor1_setting4) {
    FactoryGirl.create(:appointment_setting,
      user_id: doctor1.id,
      start_time: '11:00',
      end_time: '12:00',
      week_day: 'monday'
    )
  }

  let(:doctor2_setting) {
    # 05-24 23:00 (Perth) == 05-25 01:00 (Sydney)
    FactoryGirl.create(:appointment_setting,
      user_id: doctor2.id,
      start_time: '00:00',
      end_time: '01:00',
      week_day: 'wednesday'
    )
  }

  let(:patient1) { FactoryGirl.create(:patient, local_timezone: perth) }
  let(:patient2) { FactoryGirl.create(:patient, local_timezone: perth) }

  let(:setting1_start_time) { create_time(time: doctor1_setting1.start_time, zone: perth) }
  let(:setting1_end_time) { create_time(time: doctor1_setting1.end_time, zone: perth) }

  let(:setting2_start_time) { create_time(time: doctor1_setting2.start_time, zone: perth) }
  let(:setting2_end_time) { create_time(time: doctor1_setting2.end_time, zone: perth) }

  let(:setting1_product) {
    FactoryGirl.create(:appointment_product,
      doctor_id: doctor1.id,
      appointment_setting: doctor1_setting1,
      start_time: setting1_start_time,
      end_time: setting1_end_time
    )
  }

  let(:setting2_product) {
    FactoryGirl.create(:appointment_product,
      doctor_id: doctor1.id,
      appointment_setting: doctor1_setting2,
      start_time: setting2_start_time,
      end_time: setting2_end_time
    )
  }

  let(:setting3_product) {
    FactoryGirl.create(:appointment_product,
      doctor_id: doctor1.id,
      appointment_setting: doctor1_setting4,
      start_time: setting2_start_time,
      end_time: setting2_end_time
    )
  }

  let(:patient1_appointment1) {
  	FactoryGirl.create(:appointment,
  	doctor_id: doctor1.id,
  	patient_id: patient1.id,
       appointment_product: setting1_product)
  }

  let(:patient2_appointment2) {
  	FactoryGirl.create(:appointment,
  	doctor_id: doctor1.id,
  	patient_id: patient2.id,
      appointment_product: setting1_product)
  }

  let(:patient2_appointment1) {
      FactoryGirl.create(:appointment,
      doctor_id: doctor1.id,
      patient_id: patient2.id,
      appointment_product: setting2_product
    )
  }

  let(:medical_certificate_1){
    FactoryGirl.create(:medical_certificate,
      appointment:  patient1_appointment1
    )
  }

  let(:charge_event_log) {
    FactoryGirl.create(:charge_event_log, status: 1)
  }

  let(:transfer_event_log) {
    FactoryGirl.create(:transfer_event_log, status: 1)
  }

   let(:bank_account) { FactoryGirl.create(:bank_account, doctor: doctor1) }
   let(:token_id) {  'btok_8Xq344XtESvsfX' }
   let(:token_params) {
     {routing_number: "110000", currency: "aud", country: "AU", account_number: "000123456789"}
   }
   let(:account_params) {
     {:managed => true, :country => "AU", external_account: token_id}
   }
   let!(:stripe_account) {
     # Mock true result on validation of bank_account
     account = double(Stripe::Account, id: bank_account.account_id)
     token = double(Stripe::Token, id: token_id, bank_account: token_params)
     allow(Stripe::Token).to receive(:create).with(bank_account: token_params).and_return(token)
     allow(Stripe::Account).to receive(:create).with(account_params).and_return(account)
     allow(Stripe::Account).to receive(:retrieve).with(any_args).and_return(account)
     allow(account).to receive(:delete).and_return(true)
    }

    let!(:stripe_transfer) {
      transfer_result = double(Stripe::Transfer,  id: SecureRandom.hex, status: 'paid',)
      allow(Stripe::Transfer).to receive(:create).with(amount: 100,
                                              currency: 'aud',
                                              destination: bank_account.account_id,
                                              description: 'transfer for appointment').and_return(transfer_result)
    }

    let!(:stripe_charge){
       charge_result = double(Stripe::Charge,
        id: SecureRandom.hex,
        status: 'succeeded',
        source: { last4: '1111', brand: 'Visa' },
      )

      allow(Stripe::Charge).to(
        receive(:create)
          .with(any_args)
          .and_return(charge_result)
      )
    }

end
