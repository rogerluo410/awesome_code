RSpec.describe Appointment, type: :model do
  describe "const" do
    context "defined" do
      it { expect(Appointment).to be_const_defined(:STATUS_HASH) }
    end

    context "return correctly" do
      context "::STATUS_HASH" do
        it "normal" do
          result = Appointment::STATUS_HASH

          expect(result).to eq(
            {
              pending: 1, accepted: 2, processing: 3, finished: 4, decline: 5
            }
          )
        end
      end
    end
  end

  describe "public class methods" do
    context "responds to its methods" do
      it { expect(Appointment).to respond_to(:status_enum_hash) }
    end
  end

  describe "private instance method" do
    context "responds to it method" do
    end
  end
end
