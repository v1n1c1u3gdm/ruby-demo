class Author < ApplicationRecord
  has_many :socials, dependent: :destroy
  has_many :articles, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :birthdate, :photo_url, :public_key, :bio, presence: true
end
