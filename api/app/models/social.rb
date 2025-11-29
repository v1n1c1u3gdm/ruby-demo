class Social < ApplicationRecord
  belongs_to :author

  validates :profile_link, :slug, :description, presence: true
  validates :slug, uniqueness: true
end
