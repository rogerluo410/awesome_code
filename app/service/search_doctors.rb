class SearchDoctors < SearchBase
  def model_name
    Doctor
  end

  def match_fields
    [
      "name",
      "bio_info"
    ]
  end

  def doctor_results
    Decorator::DoctorResultsDecorator.new(search, params[:page], params[:from], params[:to]).call
  end

  def filters
    terms = [term("approved": true)]

    if params[:specialty_id].present?
      terms << term("specialty_id": params[:specialty_id])
    end

    terms << SearchTimeZoneBuilder.new(params[:from], params[:to]).call

    terms
  end

  def sorts
    sort_term([{"updated_at": "desc"}])
  end
end
