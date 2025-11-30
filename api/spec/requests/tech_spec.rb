require "rails_helper"

RSpec.describe "Tech diagnostics", type: :request do
  describe "GET /tech" do
    it "renders HTML with key sections" do
      get "/tech"

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("text/html")
      expect(response.body).to include("/tech &mdash; ruby-demo diagnostics")
      expect(response.body).to include("Licença")
    end
  end
end

