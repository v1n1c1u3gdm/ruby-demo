FactoryBot.define do
  factory :social do
    association :author
    sequence(:slug) { |n| "social-#{n}" }
    profile_link { "https://example.com/#{slug}" }
    description { "Main social profile" }
  end
end

