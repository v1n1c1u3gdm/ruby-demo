class HealthController < ApplicationController
  def liveness
    render json: { status: "ok", service: "ruby-demo-api", timestamp: Time.current }, status: :ok
  end
end

