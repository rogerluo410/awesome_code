class Admin::PatientsController < Admin::BaseController
  before_action :set_patient, only: [:edit, :update]

  def index
    @patients = Patient.order(id: :desc).page(params[:page])
  end

  def edit
  end

  def update
    if @patient.update(patient_params)
      flash[:notice] = "Update patient success"
      redirect_to admin_patients_path
    else
      render :edit
    end
  end

  private
  def set_patient
    @patient = Patient.find(params[:id])
  end

  def patient_params
    params.required(:patient).permit(:first_name, :last_name, :phone)
  end
end
