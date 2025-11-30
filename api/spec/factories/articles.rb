FactoryBot.define do
  factory :article do
    association :author
    sequence(:title) { |n| "Article Title #{n}" }
    sequence(:slug) { |n| "article-slug-#{n}" }
    published_label { "Published" }
    post_entry { "Lorem ipsum dolor sit amet." }
    tags { %w[ruby rails api] }
  end
end

