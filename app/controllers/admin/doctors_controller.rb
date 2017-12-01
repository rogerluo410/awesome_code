class Admin::DoctorsController < Admin::BaseController
  before_action :set_doctor, only: [:show, :edit, :update, :toggle_approved]

  def index
    @doctors = Doctor.includes(:doctor_profile).order(id: :desc).page(params[:page])
  end

  def show
  end

  def edit
    @doctor.build_address if @doctor.address.blank?
    @doctor.build_doctor_profile if @doctor.doctor_profile.blank?
  end

  def update
    if @doctor.update(doctor_params)
      flash[:notice] = "Update doctor success"
      redirect_to admin_doctors_path
    else
      render :edit
    end
  end

  def toggle_approved
    @doctor.build_doctor_profile if @doctor.doctor_profile.blank?

    @doctor.doctor_profile.approved = params[:approved]

    if @doctor.save
      render json: { message: 'Approved success'}
    else
      render json: { message: @doctor.errors.full_messages[0] }
    end
  end

  private
  def set_doctor
    @doctor = Doctor.find(params[:id])
  end

  def doctor_params
    params.required(:doctor).permit(:first_name, :last_name, :phone)
  end
end
