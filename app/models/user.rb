class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:twitter, :facebook]

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :identities
  enum role: [:noob, :amateur, :pro]

  before_save :default_values
  has_many :votes
  
  def default_values
    self.role ||= 0
  end

  def email_verified?
    return false if email.blank? || has_temporal_email?
    true
  end

  private

  def has_temporal_email?
    email.split("@")[1] == "change-me.com"
  end
end
