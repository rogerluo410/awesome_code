class Appointments::Create
  include Serviceable
  attr_reader :survey

  validate :validate_params!

  def initialize(patient, params)
    @params = params
    @patient = patient
  end

  def call
    valid?
    set_doctor
    set_appointment_setting
    set_start_and_end_time
    set_appointment_product_with_setting
    validate_appointment_time_must_be_today!

    transaction do
      build_appointment
      unless appointment.save
        fail! appointment.errors.full_messages[0]
      end

      @survey = build_survey(appointment.id)
      unless survey.save
        fail! survey.errors.full_messages[0]
      end
    end

    PushData::AppCreated.(appointment)

    appointment
  end

  private

  attr_reader :params, :start_time, :end_time, :appointment_setting, :doctor, :appointment_product,
    :patient, :appointment

  def validate_params!
    if params[:appointment_setting_id].blank?
      fail! "appointment_setting_id must not be blank"
    end

    if params[:start_time].blank? || params[:end_time].blank?
      fail! "start_time and end_time must not be blank."
    end

    if params[:doctor_id].blank?
      fail! "doctor_id must not be blank."
    end
  end

  def validate_appointment_time_must_be_today!
    patient_current_time = Time.current.in_time_zone(patient.local_timezone)
    patient_time_block = patient_current_time..patient_current_time.end_of_day
    appointment_time_block = start_time..end_time

    unless patient_time_block.overlaps?(appointment_time_block)
      fail! "You can only book the doctor in future time today."
    end
  end

  def set_start_and_end_time
    @start_time = Time.zone.parse(params[:start_time])
    @end_time = Time.zone.parse(params[:end_time])
  rescue ArgumentError
    fail! "start_time and end_time must be a valid value."
  end

  def set_doctor
    @doctor = Doctor.find_by_id(params[:doctor_id])
    fail! "Can not find doctor by id #{params[:doctor_id]}." unless @doctor
  end

  def set_appointment_setting
    @appointment_setting = @doctor.appointment_settings.find_by_id(params[:appointment_setting_id])
    unless @appointment_setting
      fail! "Cannot find appontment setting by id #{params[:appointment_setting_id]}."
    end
  end

  def set_appointment_product_with_setting
    @appointment_product = @appointment_setting.create_or_get_appointment_product(start_time, end_time)
    unless @appointment_product
      fail! appointment_setting.errors.full_messages[0]
    end
  end

  def build_appointment
    @appointment = patient.appointments.build(
      doctor: doctor,
      appointment_product: appointment_product,
      consultation_fee: appointment_setting.consultation_fee,
      doctor_fee: appointment_setting.doctor_fee
    )
  end

  def build_survey(appointment_id)
    if patient.surveys.blank?
      survey = patient.surveys.new
      survey.suburb = patient.address.try(:suburb)
      survey.full_name = patient.name
      survey.street_address = patient.address.try(:street_address)
      survey.gender = patient.patient_profile.try(:sex)
      survey.appointment_id = appointment_id
      survey.age = patient.patient_profile.try(:age)
      survey.reason_id = 1
      survey
    else
      survey = patient.surveys.last.dup
      survey.appointment_id = appointment_id
      survey
    end
  end
end
