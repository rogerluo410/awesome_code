class Api::V1::Patients::SurveysController < Api::V1::Patients::BaseController
  def show
    @survey = current_user.surveys.find_by(id: params[:id])

    if @survey.present?
      render json: @survey, serializer: Api::V1::SurveySerializer, root: 'data'
    else
      render_api_error status: 422, message: "couldn't find survey with the survey_id"
    end
  end

  def update
    service = Surveys::Update.(current_user, params[:id], survey_params)

    if service.success?
      render status: 200, json: { message: :success }
    else
      render_api_error status: 422, message: service.error
    end
  end

  private

  def survey_params
    params.require(:data).permit(:full_name, :suburb, :age, :gender, :street_address, :weight,
            :height, :occupation, :medical_condition, :medications, :reason_id, :allergies)
  end
end
