class User < ApplicationRecord
  default_scope {order("users.name ASC")}
  has_many :comments, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :name,:lastname,:username,presence: true
  validates :username, uniqueness: true

  def self.user_by_id(id)
    includes(comments: [:images],posts: [:images])
      .find_by_id(id)
  end

  def self.load_user
    includes(comments: [:images],posts: [:images])
      .all
  end

end
