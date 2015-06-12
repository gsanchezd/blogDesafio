class Identity < ActiveRecord::Base
  belongs_to :user
  validates :user, :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }
end
