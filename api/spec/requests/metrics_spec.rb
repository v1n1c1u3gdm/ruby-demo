require "rails_helper"

RSpec.describe "Metrics endpoint", type: :request do
  describe "GET /metrics" do
    it "returns metrics text" do
      collector = instance_double("Observability::Metrics")
      allow(Observability::Metrics).to receive(:instance).and_return(collector)
      allow(collector).to receive(:scrape).and_return([])
      allow(collector).to receive(:record_request)
      formatter = instance_double("Observability::MetricsFormatter", to_text: "# HELP")
      allow(Observability::MetricsFormatter).to receive(:new).and_return(formatter)

      get "/metrics"

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("text/plain")
      expect(response.body).to include("# HELP")
    end
  end
end

