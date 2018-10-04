if ENV['DISABLE_TIMEOUT'] || Rails.env.test?
  Rails.application.config.middleware.delete Rack::Timeout
else
  Rails.application.config.middleware.insert_before Rack::Runtime, Rack::Timeout, service_timeout: 5
end
