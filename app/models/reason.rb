class Reason

  attr_accessor :id, :text

  REASONS = [
    'Prescription Refil',
    'Doctors Certificate',
    'Specialist Referral',
    'Pathology Referral',
    'Radiology Referral',
    'Sore Throat',
    'Cold/Flu',
    'Ear Ache',
    'Eye Condition',
    'Skin Condition',
    'Asthma',
    'Diabetes',
    'Workers Compensation (follow up)',
    'Post-Surgery Follow Up',
    'Post-Surgery Prescription',
    'Blood Test Results',
    'Radiology Results',
    'Skin Disorders, Including Cysts, Acne & Dermatitis.',
    'Joint Disorders, Including Osteoarthritis',
    'Back Problems',
    'Cholesterol Problems',
    'Upper Respiratory Conditions',
    'Anxiety',
    'Depression',
    'Chronic Neurologic Disorders',
    'High Blood Pressure',
    'Headaches & Migraines',
    'Arthritis',
    'Other'
  ]

  def self.all
    REASONS.map.with_index(1) do |r, index|
      new(index, r)
    end
  end

  def self.find(id)
    new(id, REASONS[id-1])
  end

  def as_json
    {id: id, text: text}
  end

  def initialize(id, text)
    @id = id
    @text = text
  end
end
