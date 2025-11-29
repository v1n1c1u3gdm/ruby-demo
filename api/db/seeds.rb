require "json"
require "uri"

vinicius = Author.find_or_create_by!(name: "Vinicius G.D. Menezes") do |author|
  author.birthdate = Date.new(1986, 10, 7)
  author.photo_url = "https://viniciusmenezes.com/media/website/IMG_20220624_123059.jpg"
  author.public_key = ENV.fetch(
    "VINICIUS_PUBLIC_KEY",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFakePublicKeyForViniciusSeedRecord"
  )
end

[
  {
    slug: "twitter",
    profile_link: "https://twitter.com/v1n1c1u5gdm",
    description: "Perfil oficial no Twitter / X"
  },
  {
    slug: "instagram",
    profile_link: "https://www.instagram.com/vm3n3z35/",
    description: "Momentos diversos no Instagram"
  },
  {
    slug: "linkedin",
    profile_link: "https://www.linkedin.com/in/menezesvinicius/",
    description: "Perfil profissional no LinkedIn"
  }
].each do |social_attrs|
  social = vinicius.socials.find_or_initialize_by(slug: social_attrs[:slug])
  social.update!(social_attrs)
end

blog_data_path = Rails.root.join("..", "blog-data-2025-11-29.json")

if File.exist?(blog_data_path)
  blog_data = JSON.parse(File.read(blog_data_path))
  generated_at = blog_data["generated_at"].presence && Time.zone.parse(blog_data["generated_at"])

  Array(blog_data["articles"]).each do |article_data|
    url = article_data["url"]
    slug = URI.parse(url).path.split("/").reject(&:blank?).last

    article = vinicius.articles.find_or_initialize_by(slug: slug)
    article.assign_attributes(
      title: article_data["title"],
      url: url,
      published_label: article_data["date"],
      post_entry: article_data["post_entry"],
      tags: Array(article_data["tags"])
    )

    article.created_at = generated_at if article.new_record? && generated_at.present?
    article.updated_at = Time.current
    article.save!
  end
else
  Rails.logger.warn("Blog data file not found at #{blog_data_path}. Skipping article import.")
end
