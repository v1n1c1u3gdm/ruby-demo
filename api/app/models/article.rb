class Article < ApplicationRecord
  belongs_to :author

  attribute :tags, default: []

  validates :title, :url, :slug, :published_label, :post_entry, presence: true
  validates :url, :slug, uniqueness: true
  validate :tags_must_be_array

  private

  def tags_must_be_array
    errors.add(:tags, "must be an array") unless tags.is_a?(Array)
  end
end
