class Admin::ProfilesController < Admin::BaseController
  def edit
    @admin = current_admin
  end

  def edit_password
    @admin = current_admin
  end

  def update
    @admin = current_admin
    if @admin.update(admin_params)
      if @admin.unconfirmed_email.present?
        flash[:notice] = "Your email has been changed to #{@admin.unconfirmed_email}, and will be updated once you verify this address, please check your email and vifify the address."
      else
        flash[:notice] = "Update profile successfully"
      end
    else
      flash[:error] = @admin.errors.messages
    end
    redirect_to admin_edit_profile_path(@admin.username_was)
  end

  def update_password
    @admin = current_admin
    if @admin.update_with_password(params_password)
      flash[:notice] = "Update password sueccessfully"
      redirect_to admin_doctors_path
    else
      flash[:error] = @admin.errors.messages
      redirect_to admin_edit_password_path(@admin.username_was)
    end
  end

  private
  def admin_params
    params.require(:admin).permit(
      :image, :phone, :first_name, :last_name, :email, :username, :notify_sms,
      :notify_email, :notify_system, :local_timezone,
    )
  end

  def params_password
    params.required(:admin).permit(:password, :password_confirmation,
      :current_password
    )
  end
end
