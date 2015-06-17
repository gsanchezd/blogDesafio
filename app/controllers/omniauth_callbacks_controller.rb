class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    begin
      find_or_create_user
      sign_in_and_set_msg
    rescue ActiveRecord::RecordInvalid
      redirect_to_signup
    end
  end

  def after_sign_in_path_for(resource)
    return super(resource) if resource.email_verified?
    edit_finish_signup_path(resource)
  end

  alias_method :facebook, :all
  alias_method :twitter, :all

  private

  def redirect_to_signup
    provider = env["omniauth.auth"].provider
    session["devise.#{provider}_data"] = request.env["omniauth.auth"].except("extra")
    redirect_to new_user_registration_url
  end

  def sign_in_and_set_msg(login_type)
    sign_in_and_redirect(@user, event: :authentication)
    set_flash_message(:notice, :sucess) if is_navigational_format?
  end


  def find_or_create_user
    @user ||= User::FindOrCreateForOauth.new(env["omniauth.auth"]).call
  end
end
