RSpec.describe NotificationSmsJob, type: :job do
  let(:patient) { create(:patient) }
  let(:doctor) { create(:doctor) }
  let(:notification) { create(:notification, user_id: doctor.id, resource_id: patient.id, n_type: :normal) }

  describe "#perform" do
    it "perform sms job" do
      job = NotificationSmsJob.perform_later(notification)

      expect(job.arguments).to eq([notification])
    end
  end
end
