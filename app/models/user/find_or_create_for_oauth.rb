class User::FindOrCreateForOauth
  attr_reader :identity, :oauth

  def initialize(oauth)
    @oauth = oauth
    init_identity
  end

  def call
    assign_user_to_identity unless identity.persisted?
    identity.user
  end

  private

  def init_identity
    @identity ||= Identity.find_or_initialize_by(uid: oauth.uid, provider: oauth.provider)
  end

  def assign_user_to_identity
    identity.user = find_or_create_user
    identity.save
  end

  def find_or_create_user
    find_user_by_oauth || create_user_from_oauth
  end

  def find_user_by_oauth
    User.find_by(email: oauth.info.email)
  end

  def create_user_from_oauth
    User.create(
      email: temp_email,
      password: temp_password,
      password_confirmation: temp_password
    )
  end

  def temp_email
    @email_param ||= oauth.info.email || "#{oauth.uid}@change-me.com"
  end

  def temp_password
    @pass_param ||= Devise.friendly_token[0, 20]
  end
end
