class Admin::AdminsController < Admin::BaseController
  before_action :set_admin, only: [:edit, :update]

  def index
    @admins = Admin.order(id: :desc).page(params[:page])
  end

  def edit
  end

  def update
    if @admin.update(admin_params)
      flash[:notice] = "Update admin success"
      redirect_to admin_admins_path
    else
      render :edit
    end
  end

  private
  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.required(:admin).permit(:first_name, :last_name, :phone)
  end
end
