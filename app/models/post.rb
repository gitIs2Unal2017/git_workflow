class Post < ApplicationRecord
  default_scope {order("posts.name ASC")}
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy

  validates :name,:description,presence: true
  validates :name, uniqueness: true

  def self.post_by_id(id)
    includes(:user,:images,comments: [:images])
      .find_by_id(id)
  end

  def self.load_posts
    includes(:user,:images,comments: [:images])
      .all
  end

  def self.posts_by_user(id)
    includes(:user,:images,comments: [:images])
      .where(posts: {user_id: id})
  end

end
