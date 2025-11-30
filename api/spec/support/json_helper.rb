module JsonHelper
  def json_body
    JSON.parse(response.body)
  rescue JSON::ParserError
    {}
  end
end

RSpec.configure do |config|
  config.include JsonHelper, type: :request
end

