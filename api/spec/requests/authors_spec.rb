require "rails_helper"

RSpec.describe "Authors API", type: :request do
  describe "GET /authors" do
    it "returns all authors with socials" do
      create_list(:author, 2, socials: build_list(:social, 1))

      get "/authors"

      expect(response).to have_http_status(:ok)
      expect(json_body.length).to eq(2)
      expect(json_body.first).to have_key("socials")
    end
  end

  describe "GET /authors/:id" do
    it "returns an author with socials and articles" do
      author = create(:author)
      create(:article, author: author)
      create(:social, author: author)

      get "/authors/#{author.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body["socials"].length).to eq(1)
      expect(json_body["articles"].length).to eq(1)
    end
  end

  describe "POST /authors" do
    it "creates a new author" do
      payload = attributes_for(:author)

      expect do
        post "/authors", params: { author: payload }
      end.to change(Author, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "returns errors when invalid" do
      post "/authors", params: { author: { name: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_body["errors"]).to include("Name can't be blank")
    end
  end

  describe "PATCH /authors/:id" do
    it "updates an author" do
      author = create(:author)

      patch "/authors/#{author.id}", params: { author: { bio: "Updated bio" } }

      expect(response).to have_http_status(:ok)
      expect(json_body["bio"]).to eq("Updated bio")
    end
  end

  describe "DELETE /authors/:id" do
    it "removes the author" do
      author = create(:author)

      expect do
        delete "/authors/#{author.id}"
      end.to change(Author, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end

