class ApplicationController < ActionController::API
  around_action :record_observability_metrics

  private

  def record_observability_metrics
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    yield
  ensure
    duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time
    Observability::Metrics.instance.record_request(
      method: request.request_method,
      path: request.path,
      status: response&.status || 500,
      duration_seconds: duration
    )
  end
end
