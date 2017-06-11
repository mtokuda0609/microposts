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
#  validates :password_digest, 
#      presence: true, 
#      length: { in: 8..255, too_short: "最低8文字以上使ってください。" }, 
#      confirmation: true
#  validates :password_digest_confirmation, 
#      presence: true

  has_many :microposts

end