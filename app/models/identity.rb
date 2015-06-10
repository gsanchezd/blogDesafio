class Identity < ActiveRecord::Base
  belongs_to :user
  validates :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }

  class << self
    def find_or_create_by_oauth(oauth)
      find_or_create_by(uid: oauth.uid, provider: oauth.provider)
    end
  end
end
