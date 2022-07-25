class User < ApplicationRecord
    has_many :blogs
    has_secure_password
    # mount_uploader :avatar, AvatarUploader
    validates :email, presence: true, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :username, presence: true, uniqueness: true
    validates :password,
              length: { minimum: 4 },
              if: -> { new_record? || !password.nil? }
  end