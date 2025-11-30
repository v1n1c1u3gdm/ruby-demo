require "rails_helper"

RSpec.describe Article, type: :model do
  subject(:article) { build(:article) }

  it { is_expected.to belong_to(:author) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:slug) }
  it { is_expected.to validate_presence_of(:published_label) }
  it { is_expected.to validate_presence_of(:post_entry) }
  it { is_expected.to validate_uniqueness_of(:slug).case_insensitive }

  describe "#tags_must_be_array" do
    it "is invalid when tags is not an array" do
      article.tags = "invalid"

      expect(article).not_to be_valid
      expect(article.errors[:tags]).to include("must be an array")
    end

    it "is valid with array tags" do
      article.tags = %w[ruby rails]

      expect(article).to be_valid
    end
  end
end

