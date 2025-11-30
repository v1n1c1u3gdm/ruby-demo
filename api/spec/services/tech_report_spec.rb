require "rails_helper"

RSpec.describe TechReport do
  subject(:report) { described_class.new(env: { "SECRET_KEY" => "123", "APP_ENV" => "test" }) }

  before do
    allow_any_instance_of(described_class).to receive(:host_info).and_return("Hostname" => "test-host")
    allow_any_instance_of(described_class).to receive(:runtime_info).and_return("Ruby" => "3.3")
    allow_any_instance_of(described_class).to receive(:database_info).and_return("Adapter" => "mysql2")
    allow_any_instance_of(described_class).to receive(:configuration_info).and_return("Log level" => "info")
  end

  it "renders HTML with all sections" do
    html = report.render

    expect(html).to include("test-host")
    expect(html).to include("Ruby")
    expect(html).to include("Adapter")
    expect(html).to include("Log level")
    expect(html).to include("[FILTERED]")
    expect(html).to include("APP_ENV")
  end
end

