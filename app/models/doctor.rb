class Doctor < User
  include Searchable

  has_one :doctor_profile, foreign_key: :user_id
  has_many :appointment_settings, foreign_key: :user_id
  has_many :appointments, foreign_key: :doctor_id
  has_one :bank_account, foreign_key: :user_id

  accepts_nested_attributes_for :doctor_profile, :address, :bank_account, allow_destroy: true

  delegate :specialty_name, :bio_info, :years_experience, :approved, :specialty_id, to: :doctor_profile, allow_nil: true

  def self.week_days
    [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
  end

  def get_appointment_settings_by_week_day week_day
    self.appointment_settings.with_week_day(week_day) || []
  end

  def is_available_now
    plans_in_current_weekday.each do |time|
      if (time.start_time < time_now_hour_minute) && (time_now_hour_minute < time.end_time)
        appointments = time.current_appointment_product.try(:appointments)
        return true if appointments.blank?
        return true if appointments.last.try(:status_finished?)
      else
        next
      end
    end
    false
  end

  def plans_in_current_weekday
    get_appointment_settings_by_week_day current_time.strftime("%A").downcase!
  end

  def time_now_hour_minute
    current_time.strftime("%H:%M")
  end

  def total_patient_count
    appointments.with_status(:finished).count
  end

  mapping do
    indexes :local_timezone,  :index => :not_analyzed, :type => 'string'
    indexes :appointment_settings,  type: 'nested' do
      indexes :start_time, :index => :not_analyzed, :type => 'string'
      indexes :end_time, :index => :not_analyzed, :type => 'string'
    end
  end

  def as_indexed_json(options={})
    self.as_json(
      only: [:id, :name, :local_timezone, :updated_at],
      methods: [:name, :total_patient_count,
                  :specialty_name, :bio_info, :years_experience, :approved, :specialty_id
                ],
      include: {
        appointment_settings: { only: [:id, :start_time, :end_time, :week_day] }
      }
    )
  end

  private
end
