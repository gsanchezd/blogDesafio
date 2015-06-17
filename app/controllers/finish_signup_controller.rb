class FinishSignupController < ApplicationController
  before_action :load_user, only: [:edit, :update]

  def edit; end

  def update
    existing_user = User.where(email: user_params["email"]).first
    if existing_user.nil?    
      if @user.update(user_params)
        sign_in(@user, bypass: true)
        redirect_to root_path, notice: "Email updated successfully!"
      else
        render :edit
      end
    else
      identity = @user.identities.select{|x| x.provider == "twitter"}.first
      existing_user.identities << @user.identities
      @user.destroy
      sign_in(@user, bypass: true)
      redirect_to root_path, notice: "Email updated successfully!"
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
