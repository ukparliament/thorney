class HomeController < ApplicationController
  # This controller renders the home page serializer. It does not currently query the data base.
  def index
    render_page(PageSerializer::HomePageSerializer.new(request: request))
  end
end
