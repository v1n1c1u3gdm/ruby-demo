require "rails_helper"

RSpec.describe Author, type: :model do
  subject(:author) { build(:author) }

  it { is_expected.to have_many(:socials).dependent(:destroy) }
  it { is_expected.to have_many(:articles).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  it { is_expected.to validate_presence_of(:birthdate) }
  it { is_expected.to validate_presence_of(:photo_url) }
  it { is_expected.to validate_presence_of(:public_key) }
  it { is_expected.to validate_presence_of(:bio) }
end

