module Observability
  class MetricsFormatter
    TYPE_MAPPING = {
      counter: "counter",
      observable_counter: "counter",
      up_down_counter: "gauge",
      observable_up_down_counter: "gauge",
      observable_gauge: "gauge",
      gauge: "gauge"
    }.freeze

    def initialize(metric_snapshots)
      @metric_snapshots = Array(metric_snapshots)
    end

    def to_text
      lines = []

      @metric_snapshots.each do |metric|
        points = metric&.data_points
        next if points.nil? || points.empty?

        lines << "# HELP #{metric.name} #{metric.description || 'Metric emitted via OpenTelemetry'}"
        lines << "# TYPE #{metric.name} #{TYPE_MAPPING.fetch(metric.instrument_kind, 'gauge')}"

        points.each do |point|
          labels = format_labels(point.attributes)
          lines << "#{metric.name}#{labels} #{format_value(point.value)}"
        end
      end

      lines << ""
      lines.join("\n")
    end

    private

    def format_labels(attributes)
      return "" if attributes.nil? || attributes.empty?

      encoded = attributes.each_with_object([]) do |(key, value), memo|
        next if value.nil?
        memo << %(#{sanitize_label(key)}="#{escape(value)}")
      end

      return "" if encoded.empty?

      "{#{encoded.join(',')}}"
    end

    def sanitize_label(key)
      key.to_s.downcase.gsub(/[^a-z0-9_]/, "_")
    end

    def escape(value)
      value.to_s.gsub('\\', '\\\\').gsub("\n", '\\n').gsub('"', '\"')
    end

    def format_value(value)
      case value
      when Float
        value.finite? ? format("%.6f", value) : value
      else
        value
      end
    end
  end
end

