class Api::V1::SpecialtiesController < ActionController::Base
  def index
    @specialties = Specialty.all

    render json: @specialties, each_serializer: Api::V1::SpecialtySerializer, root: 'data'
  end
end
