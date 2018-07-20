# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'application_insights'

use ApplicationInsights::Rack::TrackRequest, 'c0960a0f-30ad-4a9a-b508-14c6a4f61179'

run Rails.application
