class SearchPharmacies < SearchBase
  def model_name
    Pharmacy
  end

  def match_fields
    [
      "company_name",
      "code",
      "street"
    ]
  end

  def filters
    terms = [not_term(email: '')]
    terms
  end

  def sorts
    sort_term([{"id": "desc"}])
  end
end
