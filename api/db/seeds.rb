require_relative "article_seed_data"

vinicius = Author.find_or_create_by!(name: "Vinicius G.D. Menezes") do |author|
  author.birthdate = Date.new(1986, 10, 7)
  author.photo_url = "https://viniciusmenezes.com/media/website/IMG_20220624_123059.jpg"
  author.public_key = ENV.fetch(
    "VINICIUS_PUBLIC_KEY",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFakePublicKeyForViniciusSeedRecord"
  )
  author.bio = <<~BIO.strip
    Filho competente, irmão implicante, pai de menina, apaixonado por motos, namorado fiel e eterno educador. Adoro filme, vídeo-game, andar de moto, cerveja de trigo, chocolate e programar. Esse sou eu.<br><br>Profissionalmente orientado pela agilidade, unindo tecnologia e liderança para impulsionar equipes em direção à excelência. Minha abordagem é enraizada na colaboração e na comunicação transparente, criando um ambiente onde a inovação floresce e cada membro da equipe é capacitado a contribuir plenamente. Através da implementação de práticas ágeis, busco otimizar nossos processos, maximizar a eficiência e alcançar resultados excepcionais, sempre com foco no crescimento conjunto e no alcance de metas ambiciosas.
  BIO
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

generated_at_string = ARTICLE_SEED_METADATA[:generated_at]
generated_at_timestamp =
  if generated_at_string.present?
    Time.zone.parse(generated_at_string)
  else
    Time.current
  end

ARTICLE_SEED_DATA.each do |article_attrs|
  article = vinicius.articles.find_or_initialize_by(slug: article_attrs.fetch(:slug))
  article.assign_attributes(
    title: article_attrs.fetch(:title),
    published_label: article_attrs.fetch(:published_label),
    post_entry: article_attrs.fetch(:post_entry),
    tags: Array(article_attrs[:tags])
  )

  article.created_at = generated_at_timestamp
  article.updated_at = generated_at_timestamp
  article.save!
end
