class Pharmacy < ApplicationRecord
  # include Searchable

  default_scope { order(updated_at: :desc) }

  scope :valid_email, -> { where.not(email: nil) }

  enum states: [ :NT, :QLD, :NSW, :VIC, :SA,  :ACT, :WA, :TAS ]
  enum categories: [ :'Chemists\' Supplies', :'Chemists--Consulting & Industrial', :'Pharmacists--Consultant', :'Pharmacies']

  def pharmacy_name
    company_name
  end

  mapping do
    indexes :email, type: :string, null_value: '', index: :not_analyzed
    indexes :code, type: :string
  end

  def as_indexed_json(options={})
    self.as_json(
      only: [:id, :company_name, :code, :street, :email, :phone]
      )
  end
end
