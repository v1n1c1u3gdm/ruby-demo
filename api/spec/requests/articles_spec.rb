require "rails_helper"

RSpec.describe "Articles API", type: :request do
  describe "GET /articles" do
    it "lists all articles" do
      create_list(:article, 2)

      get "/articles"

      expect(response).to have_http_status(:ok)
      expect(json_body.length).to eq(2)
    end
  end

  describe "GET /articles/:id" do
    it "returns the article" do
      article = create(:article)

      get "/articles/#{article.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body["id"]).to eq(article.id)
    end
  end

  describe "POST /articles" do
    it "creates an article" do
      author = create(:author)
      payload = attributes_for(:article, author_id: author.id)

      expect do
        post "/articles", params: { article: payload }
      end.to change(Article, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "returns validation errors" do
      post "/articles", params: { article: { title: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_body["errors"]).to include("Title can't be blank")
    end
  end

  describe "PATCH /articles/:id" do
    it "updates an article" do
      article = create(:article)

      patch "/articles/#{article.id}", params: { article: { title: "Updated" } }

      expect(response).to have_http_status(:ok)
      expect(json_body["title"]).to eq("Updated")
    end
  end

  describe "DELETE /articles/:id" do
    it "deletes the article" do
      article = create(:article)

      expect do
        delete "/articles/#{article.id}"
      end.to change(Article, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe "GET /articles/count_by_author" do
    it "returns count per author" do
      author_with_articles = create(:author, name: "Alice")
      create_list(:article, 2, author: author_with_articles)
      author_without_articles = create(:author, name: "Bob")

      get "/articles/count_by_author"

      expect(response).to have_http_status(:ok)
      expect(json_body).to include(
        a_hash_including("author_id" => author_with_articles.id, "articles_count" => 2),
        a_hash_including("author_id" => author_without_articles.id, "articles_count" => 0)
      )
    end
  end
end

