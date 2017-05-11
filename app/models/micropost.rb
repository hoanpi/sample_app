class Micropost < ApplicationRecord
  belongs_to :user
  
  scope :ordered, ->{order created_at: :desc}
  scope :post_feed, ->user_ids{where user_id: user_ids}
  
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  private
    def picture_size
      if picture.size > 5.megabytes
        errors.add :picture, I18n.t("picture_size_err")
      end
    end
end
