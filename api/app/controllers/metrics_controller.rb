class MetricsController < ApplicationController
  def show
    metrics = Observability::Metrics.instance.scrape
    payload = Observability::MetricsFormatter.new(metrics).to_text

    render plain: payload, content_type: "text/plain; version=0.0.4"
  end
end

