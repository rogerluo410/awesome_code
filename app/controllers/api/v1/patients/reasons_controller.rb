class Api::V1::Patients::ReasonsController < Api::V1::Patients::BaseController

  def index
    reasons = Reason.all.map(&:as_json)
   
    render json: { data: reasons }
  end

end