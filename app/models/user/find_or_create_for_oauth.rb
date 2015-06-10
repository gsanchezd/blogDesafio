class User::FindOrCreateForOauth
  def initialize(args)
    @current_user = args[:current_user] || nil
    @oauth = args[:oauth]
  end

  def call
    user = find_user || create_user_from_oauth
    assign_user_to_identity(user)
    user
  end

  private

  def create_user_from_oauth
    User.create(
      email: email_param,
      password: pass_param,
      password_confirmation: pass_param
    )
  end

  def email_param
    @email_param ||= @oauth.info.email || "#{@oauth.uid}@change-me.com"
  end

  def pass_param
    @pass_param ||= Devise.friendly_token[0, 20]
  end

  def find_user
    @current_user || identity.user || find_user_by_oauth
  end

  def find_user_by_oauth
    User.find_by(email: @oauth.info.email)
  end

  def identity
    @identity ||= Identity.find_or_create_by_oauth(@oauth)
  end

  def assign_user_to_identity(user)
    identity.user = user
    identity.save
  end
end
