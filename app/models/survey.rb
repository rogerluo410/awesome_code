class Survey < ApplicationRecord
  extend Enumerize

  belongs_to :patient, foreign_key: :user_id
  belongs_to :appointment

  GENDER_HASH = {
    male: 1,
    female: 0
  }

  enumerize :gender, in: GENDER_HASH,
            default: :female

  def reason
    reason_id.presence && Reason.find(reason_id).try(:text)
  end

end
