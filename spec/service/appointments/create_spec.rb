RSpec.describe Appointments::Create do
  subject { described_class.(patient, params) }

  let(:perth) { 'Australia/Perth' }
  let(:date) { '2016-05-24' }
  let(:start_time) { '10:00' }
  let(:end_time) { '11:00' }

  let!(:patient) { FactoryGirl.create(:patient, local_timezone: perth) }
  let!(:params) {
    {
      appointment_setting_id: app_setting.id,
      start_time: "#{date} #{start_time}".in_time_zone(perth).to_s(:iso8601),
      end_time: "#{date} #{end_time}".in_time_zone(perth).to_s(:iso8601),
      doctor_id: doctor.id,
    }
  }

  let!(:address) {
    FactoryGirl.create(:address,
      user: patient,
      suburb: FFaker::AddressAU.suburb,
      street_address: FFaker::AddressAU.street_address,
    )
  }
  let!(:patient_profile) {
    FactoryGirl.create(:patient_profile,
      patient: patient,
      sex: 'male',
      birthday: "2000-01-01",
    )
  }

  let!(:doctor) { FactoryGirl.create(:doctor, local_timezone: perth) }
  let!(:app_setting) {
    FactoryGirl.create(:appointment_setting,
      doctor: doctor,
      start_time: start_time,
      end_time: end_time,
      week_day: 'tuesday',
    )
  }

  before do
    allow(PushData::AppCreated).to receive(:call)
    travel_to "2016-05-24 10:00".in_time_zone(perth)
  end

  after do
    travel_back
  end

  it "creates the appointment and survey" do
    subject

    expect(subject).to be_success

    app = subject.result
    app.reload

    expect(app).to be_persisted
    expect(app.survey).to be_persisted

    survey = app.survey
    expect(survey.suburb).to eq(address.suburb)
    expect(survey.full_name).to eq(patient.name)
    expect(survey.street_address).to eq(address.street_address)
    expect(survey.gender).to eq(patient_profile.sex)
    expect(survey.age).to eq(16)

    expect(PushData::AppCreated).to have_received(:call).with(app)
  end
end
