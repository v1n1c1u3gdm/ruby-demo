require "rails_helper"

RSpec.describe "Health endpoints", type: :request do
  describe "GET /liveness" do
    it "returns ok status" do
      get "/liveness"

      expect(response).to have_http_status(:ok)
      expect(json_body["status"]).to eq("ok")
    end
  end
end

