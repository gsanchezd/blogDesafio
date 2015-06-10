class FinishSignupController < ApplicationController
  before_action :load_user, only: [:edit, :update]

  def edit; end

  def update
    if @user.update(user_params)
      sign_in(@user, bypass: true)
      redirect_to root_path, notice: "Email updated successfully!"
    else
      render :edit
    end
  end

  private

  def load_user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
