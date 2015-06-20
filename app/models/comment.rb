class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  
  has_many :votes, as: :votable
  has_many :users_who_voted, through: :votes, :source => :user

  validates :content, presence: true
end
