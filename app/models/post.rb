class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  belongs_to :user
  mount_uploader :photo, PictureUploader
  validates :title, presence: true
  has_many :votes, as: :votable
  has_many :users_who_voted, through: :votes, :source => :user

end
