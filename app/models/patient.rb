class Patient < User
  has_many :authorizations, foreign_key: :user_id
  has_many :appointments, foreign_key: :patient_id
  has_many :checkouts, foreign_key: :user_id
  has_one :patient_profile, foreign_key: :user_id
  has_many :surveys, foreign_key: :user_id

  accepts_nested_attributes_for :patient_profile, :address, allow_destroy: true

  def self.from_omniauth(auth, current_user)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s, token: auth.credentials.token, secret: auth.credentials.secret).first_or_initialize
    if authorization.patient.blank?
      patient = current_user || Pateint.where('email = ?', auth["info"]["email"]).first
      if patient.blank?
        patient = Pateint.new
        patient.password = Devise.friendly_token[0,10]
        patient.first_name = auth.info.first_name
        patient.last_name = auth.info.last_name
        patient.email = auth.info.email
        patient.save
      end
      authorization.username = auth.info.nickname
      authorization.user_id = patient.id
      authorization.save
    end
    authorization.patient
  end
end
