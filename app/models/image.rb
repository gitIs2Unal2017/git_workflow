class Image < ApplicationRecord
  default_scope {order("images.created_at")}
  belongs_to :imageable, polymorphic: true

  validates :image,presence: true

  def self.image_by_id(id)
    find_by_id(id)
  end

  def self.load_images
    all
  end

  def self.images_by_comment_or_post_id(id,type)
    where(images: {imageable_id: id})
      .where(images: {imageable_type: type})
  end


end
