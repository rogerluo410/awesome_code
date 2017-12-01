RSpec.describe NotificationWebJob, type: :job do
  let(:patient) { create(:patient) }
  let(:doctor) { create(:doctor) }
  let(:notification) { create(:notification, user_id: doctor.id, resource_id: patient.id, n_type: :normal) }

  describe "#perform" do
    it "perform web broadcast job" do
      job = NotificationWebJob.perform_now(notification)

      expect(job).to eq(true)
    end
  end
end
