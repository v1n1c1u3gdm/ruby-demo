require "rails_helper"

RSpec.describe "Socials API", type: :request do
  describe "GET /socials" do
    it "returns all socials" do
      create_list(:social, 3)

      get "/socials"

      expect(response).to have_http_status(:ok)
      expect(json_body.size).to eq(3)
    end
  end

  describe "GET /socials/:id" do
    it "returns a social" do
      social = create(:social)

      get "/socials/#{social.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body["id"]).to eq(social.id)
    end
  end

  describe "POST /socials" do
    it "creates a social entry" do
      author = create(:author)
      payload = attributes_for(:social, author_id: author.id)

      expect do
        post "/socials", params: { social: payload }
      end.to change(Social, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "returns validation errors when invalid" do
      post "/socials", params: { social: { slug: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_body["errors"]).to include("Slug can't be blank")
    end
  end

  describe "PATCH /socials/:id" do
    it "updates a social entry" do
      social = create(:social)

      patch "/socials/#{social.id}", params: { social: { description: "Updated" } }

      expect(response).to have_http_status(:ok)
      expect(json_body["description"]).to eq("Updated")
    end
  end

  describe "DELETE /socials/:id" do
    it "deletes a social entry" do
      social = create(:social)

      expect do
        delete "/socials/#{social.id}"
      end.to change(Social, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end

