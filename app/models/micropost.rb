class Micropost < ApplicationRecord
  belongs_to :user

  # 削除する場合は、依存するリレーションも同時に削除するため、dependent オプションが必要になる
  has_many :favorites, foreign_key: 'micropost_id', dependent: :destroy
  has_many :fav_users, through: :favorites, source: :user
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }

end
