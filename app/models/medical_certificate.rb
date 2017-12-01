class MedicalCertificate < ApplicationRecord
  belongs_to :appointment
  mount_uploader :file, MedicalCertificateFileUploader
  validates :file, presence: true

  def notify_receiver
    Notification.create(user_id: appointment.patient_id,
                    resource_id: id,
                    resource_type: 'MedicalCertificate',
                    n_type: 'meidcal_certificate',
                )
  end
end
