class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    load_user
    sign_in_or_finish_signup("twitter")
  end

  def facebook
    load_user
    sign_in_or_finish_signup("facebook")
  end

  def after_sign_in_path_for(resource)
    return super(resource) if resource.email_verified?
    edit_finish_signup_path(resource)
  end

  private

  def sign_in_or_finish_signup(login_type)
    if @user.persisted?
      sign_in_and_redirect(@user, event: :authentication)
      set_flash_message(:notice, :sucess, kind: login_type) if is_navigational_format?
    else
      session["devise.#{login_type}_data"] = env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end


  def load_user
    @user ||= User::FindOrCreateForOauth.new(oauth: env["omniauth.auth"],
                                             current_user: current_user).call
  end
end
