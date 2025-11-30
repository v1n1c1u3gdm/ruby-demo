return if defined?(Rails::Console)

require Rails.root.join("lib/observability/metrics").to_s
require Rails.root.join("lib/observability/metrics_formatter").to_s

Observability::Metrics.instance

