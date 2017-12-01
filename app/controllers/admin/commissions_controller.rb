class Admin::CommissionsController < Admin::BaseController
  def index
    @commissions = AppointmentSetting::TIME_PERIODS
  end
end
