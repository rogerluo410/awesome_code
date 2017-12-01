class PatientProfile < ApplicationRecord
  extend Enumerize
  belongs_to :patient, foreign_key: :user_id

  SEX_HASH = {
      male: 0, female: 1,
  }

  enumerize :sex, in: SEX_HASH,
            scope: true,
            default: :male

  def age
    return nil if birthday.blank?
    now = Time.current.in_time_zone(patient.local_timezone).to_date
    now.year - birthday.year - (birthday.change(year: now.year) > now ? 1 : 0)
  end
end
