class Admin::SessionsController < Devise::SessionsController
  layout 'admin'

  def create
    @user = User.find_by_email(params[:user][:email])
    if @user.present? && (@user.type != 'Admin')
      flash[:notice] = "You are a #{@user.type}, can not login as an admin"
      return redirect_to new_admin_session_path
    end

    service = Auth::WebLoginUser.call(admin_params)

    if service.success?
      sign_in('user', service.result)

      flash[:notice]= 'Sign in success'
      redirect_to admin_doctors_path
    else
      flash[:error] = service.errors
      redirect_to new_admin_session_path
    end
  end

  def destroy
    super
    cookies.clear
  end

  private
  def admin_params
    params.require(:user).permit(:email, :password)
  end
end
