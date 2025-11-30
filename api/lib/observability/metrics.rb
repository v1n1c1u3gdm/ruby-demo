require "singleton"
require "opentelemetry/sdk"
require "opentelemetry-metrics-sdk"
require "opentelemetry/instrumentation/all"

module Observability
  class Metrics
    include Singleton

    SERVICE_NAME = "ruby-demo-api"

    def initialize
      @exporter = OpenTelemetry::SDK::Metrics::Export::InMemoryMetricPullExporter.new
      configure_sdk
      build_instruments
    end

    def record_request(method:, path:, status:, duration_seconds:)
      attributes = base_attributes.merge(
        "http.method": method,
        "http.route": normalize_path(path),
        "http.status_code": status.to_i
      )

      @request_counter.add(1, attributes: attributes)
      @duration_sum_counter.add(duration_seconds, attributes: attributes)
      @duration_count_counter.add(1, attributes: attributes)
    rescue StandardError => e
      Rails.logger.warn("Failed to record metrics: #{e.class} - #{e.message}") if defined?(Rails)
    end

    def scrape
      @exporter.pull
      snapshot = @exporter.metric_snapshots.dup
      @exporter.reset
      snapshot
    end

    private

    def configure_sdk
      ENV["OTEL_TRACES_EXPORTER"] ||= "none"
      ENV["OTEL_METRICS_EXPORTER"] ||= "none"

      OpenTelemetry::SDK.configure do |c|
        c.resource = OpenTelemetry::SDK::Resources::Resource.create(
          "service.name" => SERVICE_NAME,
          "service.namespace" => "ruby-demo"
        )
        c.use_all
        c.add_metric_reader(@exporter)
      end
    end

    def build_instruments
      meter = OpenTelemetry.meter_provider.meter(SERVICE_NAME, version: "0.1.0")
      @request_counter = meter.create_counter(
        "http_server_requests_total",
        unit: "{request}",
        description: "Total HTTP requests received by the API"
      )
      @duration_sum_counter = meter.create_counter(
        "http_server_request_duration_seconds_sum",
        unit: "s",
        description: "Total time spent processing HTTP requests"
      )
      @duration_count_counter = meter.create_counter(
        "http_server_request_duration_seconds_count",
        unit: "{request}",
        description: "Number of HTTP requests measured for duration"
      )
      meter.create_observable_gauge(
        "service_liveness",
        description: "Indicates if the API process is alive",
        callback: lambda do |observer|
          observer.observe(1, attributes: base_attributes.merge(state: "alive"))
        end
      )
    end

    def base_attributes
      { service: SERVICE_NAME }
    end

    def normalize_path(path)
      path.to_s.gsub(%r{/\d+}, "/:id")
    end
  end
end

