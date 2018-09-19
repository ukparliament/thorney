require 'parliament'
require 'parliament/open_search'

class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  include ActionController::Cookies
  include ApplicationHelper
  include HousesHelper

  attr_reader :app_insights_request_id

  before_action :populate_request_id, :reset_alternates

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # Rescues from a Parliament::ClientError and raises an ActionController::RoutingError
  rescue_from Parliament::ClientError do |error|
    raise ActionController::RoutingError, error.message
  end

  # Rescues from a Parliament::NoContentResponseError and raises an ActionController::RoutingError
  rescue_from Parliament::NoContentResponseError do |error|
    raise ActionController::RoutingError, error.message
  end

  # Renders a page given a page serializer
  #
  # @param [PageSerializer] serializer a page serializer that is used to create JSON
  # @param [ActionDispatch::Response] response_parameter a response object that is used to set headers
  def render_page(serializer, response_parameter = response)
    response_parameter.headers['Content-Type'] = 'application/x-shunter+json'

    render json: serializer.to_h
  end

  def populate_request_id
    @app_insights_request_id = request.env['ApplicationInsights.request.id']
  end
end
