class Appointment < ApplicationRecord
  extend Enumerize
  include AASM
  include AppointmentExtQueue
  include AppointmentExtNotify

  belongs_to :doctor, foreign_key: :doctor_id
  belongs_to :patient, foreign_key: :patient_id
  belongs_to :appointment_product
  has_many :conferences
  has_one :charge_event
  has_many :charge_event_logs, through: :charge_event
  has_many :transfer_event_logs, through: :transfer_event

  has_one :transfer_event
  has_one :survey
  has_one :refund_request
  has_many :comments
  has_many :prescriptions, -> { not_deleted }
  has_one :medical_certificate

  validates :doctor_id, :patient_id, :appointment_product_id, presence: true
  validate :patient_have_one_pending_appointment, on: :create
  validate :doctor_available, on: :create

  after_create :notify_doctor, :appointment_push_to_queue, :create_transaction_events

  scope :available, -> {
    joins(:appointment_product).where("(appointment_products.end_time)> ?", Time.current).order("appointment_products.start_time", :status, :id)
  }
  scope :unfinished, -> { with_status(:pending, :accepted, :processing) }
  scope :upcoming, -> { with_status(:accepted, :processing) }
  scope :ended, -> { with_status(:finished, :decline) }
  scope :scheduled, -> { with_status(:pending, :accepted) }

  STATUS_HASH = {
    pending: 1, accepted: 2, processing: 3, finished: 4, decline: 5
  }

  DEFAULT_TRANSFER_TIME = 10.minutes

  enumerize :status, in: STATUS_HASH,
            scope: true,
            default: :pending,
            predicates: {prefix: true}

  def self.status_enum_hash
    STATUS_HASH.with_indifferent_access
  end

  aasm column: :status, enum: :status_enum_hash do
    state :pending, initial: true
    state :accepted
    state :decline
    state :processing
    state :finished

    event :event_accepted, after: [:notify_patient] do
      transitions from: [:pending], to: :accepted
    end

    event :event_decline, after: [:notify_patient, :appointment_remove_from_queue] do
      transitions from: [:pending], to: :decline
    end

    event :event_processing, after: [:notify_patient] do
      transitions from: [:accepted], to: :processing
    end

    event :event_finished, after: [:notity_next_patient, :appointment_remove_from_queue, :default_transfer] do
      transitions from: [:processing], to: :finished
    end
  end

  # For query methods
  class << self
    def get_by_patient_active(patient)
      for_patient(patient).unfinished.order(:id).last
    end

    def get_list_by_patient_finished(patient, page: nil, limit: nil)
      page = page.presence || 1

      for_patient(patient)
        .ended
        .left_joins(:appointment_product)
        .order(id: :desc)
        .preload(:appointment_product, :survey, :charge_event, doctor: { doctor_profile: :specialty })
        .page(page)
        .per(limit)
    end

    def get_doctor_upcoming(doctor)
      for_doctor(doctor)
        .joins(:appointment_product).order("appointment_products.start_time")
        .upcoming.order(:id).first
    end

    def get_by_doctor_and_id(doctor, id)
      for_doctor(doctor).find(id)
    end

    def get_by_patient_and_id(patient, id)
      for_patient(patient).find(id)
    end

    def get_doctor_finished(doctor, page: nil, limit: nil)
      page = page.presence || 1

      for_doctor(doctor)
        .with_status(:finished)
        .order(id: :desc)
        .preload(:patient, :survey, :conferences)
        .page(page)
        .per(limit)
    end

    private

    def for_patient(patient)
      where(patient: patient)
    end

    def for_doctor(doctor)
      where(doctor: doctor)
    end
  end

  def create_transaction_events
    create_transfer_event if transfer_event.blank?
    create_charge_event if charge_event.blank?
  end

  def default_transfer
    job = AppointmentTransfersJob.set(wait: Appointment::DEFAULT_TRANSFER_TIME).perform_later(self)
    self.update(job_id: job.job_id) if job.present?
  end

  def delete_default_transfer
    if job_id.present?
      ss = Sidekiq::ScheduledSet.new
      ss.select { |id| job_id }.each(&:delete)
      self.update(job_id: nil)
    end
  end

  def is_appointment_available?
    appointment_product.end_time > Time.current + 10.minute
  end

  def paid?
    if charge_event.present?
      return charge_event.succeeded?
    else
      create_charge_event
      return false
    end
  end

  def transferred?
    if transfer_event.present?
      return transfer_event.succeeded?
    else
      create_transfer_event
      return false
    end
  end

  def application_fee
    consultation_fee - doctor_fee
  end

  private

  def patient_have_one_pending_appointment
    if self.patient.appointments.available.unfinished.present?
      errors.add(:base, 'You have already booked an appointment today, Please waiting for the consultation.')
    end
  end

  def doctor_available
    if appointment_product.available_slots <= 0
      errors.add(:base, 'There is no free slot to book an appointment at this period')
    end
  end
end
