require "rails_helper"

RSpec.describe Observability::MetricsFormatter do
  MetricData = Struct.new(:name, :description, :instrument_kind, :data_points)
  DataPoint = Struct.new(:attributes, :value)

  describe "#to_text" do
    it "renders metrics in OpenMetrics format" do
      metrics = [
        MetricData.new(
          "http_requests_total",
          "Total requests",
          :counter,
          [
            DataPoint.new({ "http.method": "GET", path: "/articles/1" }, 10),
            DataPoint.new({}, 5)
          ]
        ),
        MetricData.new(
          "service_liveness",
          nil,
          :observable_gauge,
          [
            DataPoint.new({ state: "alive", note: "multi\nline" }, 1.234567)
          ]
        )
      ]

      text = described_class.new(metrics).to_text

      expect(text).to include("# HELP http_requests_total Total requests")
      expect(text).to include("# TYPE http_requests_total counter")
      expect(text).to include('http_requests_total{http_method="GET",path="/articles/1"} 10')
      expect(text).to include("http_requests_total 5")
      expect(text).to include("# HELP service_liveness Metric emitted via OpenTelemetry")
      expect(text).to include('# TYPE service_liveness gauge')
      expect(text).to include('service_liveness{state="alive",note="multi\nline"} 1.234567')
    end

    it "returns an empty string when no datapoints exist" do
      metrics = [MetricData.new("empty_metric", "No data", :gauge, [])]

      text = described_class.new(metrics).to_text

      expect(text).to eq("")
      expect(text).not_to include("empty_metric{")
    end
  end
end

