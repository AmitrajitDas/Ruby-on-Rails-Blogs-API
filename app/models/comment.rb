class Comment < ApplicationRecord
  belongs_to :blog
  belongs_to :user
  validates :body, presence: true, length: { minimum: 1 }
end
