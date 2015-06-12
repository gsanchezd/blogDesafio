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
    @identity ||= Identity.find_or_initialize_by(oauth_params)
  end

  def assign_user_to_identity
    identity.user = find_or_create_user
    identity.save!
  end

  def find_or_create_user
    User.where(oauth_params).first_or_create do |u|
      u.email = temp_email
      u.password = temp_password
      u.password_confirmation = temp_password
    end
  end

  def oauth_params
    oauth.slice(:uid, :provider)
  end

  def temp_email
    @email_param ||= oauth.info.email || "#{oauth.uid}@change-me.com"
  end

  def temp_password
    @pass_param ||= Devise.friendly_token[0, 20]
  end
end
