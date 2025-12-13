class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all.order(:email)
  end

  def toggle_admin
    user = Userfind(params[:id])
    user.update(admin: !user.admin)
    redirect_to admin_users_path, notice: "User updated."
  end
end
