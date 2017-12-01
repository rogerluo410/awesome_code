RSpec.describe AppointmentSetting, type: :model do
  let(:doctor) { FactoryGirl.create(:doctor) }
  let(:available_time) { FactoryGirl.create(:appointment_setting, user_id: doctor.id) }

  describe "const" do
    context "defined" do
      it { expect(AppointmentSetting).to be_const_defined(:MIN_DURATION_MIN) }
    end

    context "return correctly" do
      context '::MIN_DURATION_MIN' do
        it 'normal' do
          result = AppointmentSetting::MIN_DURATION_MIN

          expect(result).to eq(15)
        end
      end
    end
  end

  describe 'public class methods' do
    context 'responds to its methods' do
      it { expect(AppointmentSetting).to respond_to(:with_week_day).with(1) }
    end
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(available_time).to respond_to(:start_time) }
      it { expect(available_time).to respond_to(:end_time) }
      it { expect(available_time).to respond_to(:consultation_fee) }
      it { expect(available_time).to respond_to(:doctor_fee) }
      it { expect(available_time).to respond_to(:application_fee) }
      it { expect(available_time).to respond_to(:available_slots) }
      it { expect(available_time).to respond_to(:total_slot_number) }
    end

    context 'excute correctly' do
      #TODO
    end
  end
end
