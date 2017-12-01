puts 'create doctor'
doctors = []
doctor = FactoryGirl.create :doctor, email: 'doctor@example.com'
20.times do |time|
  _doctor = FactoryGirl.create :doctor
  doctors << _doctor
end

puts 'create patient'
10.times do
  FactoryGirl.create :patient
end

puts 'create doctor profile'
FactoryGirl.create :doctor_profile, user_id: doctor.id
FactoryGirl.create :address, user_id: doctor.id
doctors.each do |doctor|
  FactoryGirl.create :doctor_profile, user_id: doctor.id
  FactoryGirl.create :address, user_id: doctor.id
end

puts 'create doctor appointment setting'
doctors.each do |doctor|
  [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday].each do |week|
    FactoryGirl.create :appointment_setting, user_id: doctor.id, week_day: week
  end
end

time = Time.current.in_time_zone(doctor.local_timezone)

puts 'create appointment_setting'
appointment_setting = FactoryGirl.create(:appointment_setting,
                                         user_id: doctor.id, start_time: '22:00', end_time: '23:00',
                                         week_day: time.strftime('%A').downcase!)

puts 'create appointment_product'
appointment_product = FactoryGirl.create(:appointment_product,
                                         appointment_setting: appointment_setting,
                                         doctor_id: doctor.id,
                                         start_time: time.change(hour: 22),
                                         end_time: time.change(hour: 23),
)

puts 'create appointment'
appointment = FactoryGirl.create(:appointment, doctor_id: doctor.id, patient_id: Patient.first.id,
                                 appointment_product: appointment_product, consultation_fee: appointment_setting.consultation_fee, doctor_fee: appointment_setting.doctor_fee)


puts 'create patient notification'
10.times do
  FactoryGirl.create :notification, user_id: Patient.first.id,
                     resource_id: appointment.id, resource_type: 'Appointment'
end

