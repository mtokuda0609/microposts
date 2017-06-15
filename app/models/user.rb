class User < ApplicationRecord
  validates :name, 
      presence: true,
      length: { maximum: 255 }
 
  before_save { self.email.downcase! }
  validates :email, 
      presence: true, 
      length: { maximum: 255 }, 
      format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, 
      uniqueness: { case_sensitive: false }
 
  has_secure_password

  has_many :microposts
  
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user

  has_many :favorites, foreign_key: 'user_id'
  has_many :fav_microposts, through: :favorites, source: :micropost


# フォロー/アンフォロー
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end

  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end

# お気に入り
  def fav(micropost)
    self.favorites.find_or_create_by(micropost_id: micropost.id)
  end
    
  def unfav(micropost)
    favorite = self.favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end
  
  def fav?(micropost)
    self.fav_microposts.include?(micropost)
  end

end
