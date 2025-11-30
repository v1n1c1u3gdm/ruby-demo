require "rails_helper"

RSpec.describe Social, type: :model do
  subject(:social) { build(:social) }

  it { is_expected.to belong_to(:author) }
  it { is_expected.to validate_presence_of(:profile_link) }
  it { is_expected.to validate_presence_of(:slug) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_uniqueness_of(:slug).case_insensitive }
end

