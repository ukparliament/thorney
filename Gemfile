source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'

# Use Puma as the app server
gem 'puma', '~> 3.11'
gem 'rack-timeout'

# Gem to remove trailing slashes
gem 'rack-rewrite'

# Use Parliament-Ruby for web requests
gem 'parliament-ruby', '~> 0.8'

# Use Parliament-Opensearch to handle our Opensearch requests
gem 'parliament-opensearch', '~> 0.4', require: false

# Parliament Grom Decorators decorates Grom nodes
gem 'parliament-grom-decorators', '~> 0.2'

# Parliament routing
gem 'parliament-routes', '~> 0.6'

# Use bandiera-client for feature flagging
gem 'bandiera-client'

gem 'sanitize'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'application_insights'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.7'
  gem 'simplecov'
  gem 'coveralls'
  gem 'capybara'
  gem 'vcr'
  gem 'webmock'
  gem 'rubocop'
  gem 'rails-controller-testing'
  gem 'timecop'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
