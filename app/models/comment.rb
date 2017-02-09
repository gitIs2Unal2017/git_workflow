class Comment < ApplicationRecord
  default_scope {order("comments.created_at ASC")}
  belongs_to :user
  belongs_to :post
  has_many :images, as: :imageable, dependent: :destroy


  validates :description,presence: true

  def self.comment_by_id(id)
    includes(:user,post:[:images])
      .find_by_id(id)
  end

  def self.load_comments
    includes(:user,post: [:images])
      .all
  end

  def self.comments_by_user(id)
    includes(:user,post: [:images])
      .where(comments:{user_id: id})
  end

end
