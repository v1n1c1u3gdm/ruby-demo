FactoryBot.define do
  factory :author do
    sequence(:name) { |n| "Author #{n}" }
    birthdate { Date.new(1990, 1, 1) }
    photo_url { "https://example.com/photos/#{SecureRandom.uuid}.jpg" }
    public_key { SecureRandom.hex(16) }
    bio { "Software developer and writer" }
  end
end

