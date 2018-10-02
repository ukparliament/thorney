class HomeController < ApplicationController
  # This controller renders the home page serializer. It does not currently query the data base.
  def index
    render_page(PageSerializer::HomePageSerializer.new(request_id: app_insights_request_id, request_original_url: request.original_url))
  end
end
