# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'application_insights'

use ApplicationInsights::Rack::TrackRequest, ENV['APPLICATION_INSIGHTS_INSTRUMENTATION_KEY']

run Rails.application
