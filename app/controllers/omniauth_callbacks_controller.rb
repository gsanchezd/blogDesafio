class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :load_user, only: [:twitter, :facebook]

  def twitter
    sign_in_and_set_msg("twitter")
  end

  def facebook
    sign_in_and_set_msg("facebook")
  end

  def after_sign_in_path_for(resource)
    return super(resource) if resource.email_verified?
    edit_finish_signup_path(resource)
  end

  private

  def sign_in_and_set_msg(login_type)
    sign_in_and_redirect(@user, event: :authentication)
    set_flash_message(:notice, :sucess, kind: login_type) if is_navigational_format?
  end


  def load_user
    @user ||= User::FindOrCreateForOauth.new(
      oauth: env["omniauth.auth"],
      current_user: current_user
    ).call
  end
end
