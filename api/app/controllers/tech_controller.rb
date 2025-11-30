class TechController < ApplicationController
  def show
    report = TechReport.new
    render html: report.render.html_safe, content_type: "text/html"
  end
end

