source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

gem 'umd_lib_style', github: 'umd-lib/umd_lib_style', ref: '2.0.0'

gem 'kaminari', '>=1.2.1'
gem 'ransack', '>= 2.4.2'

gem 'dotenv-rails', '>= 2.7.6'
# AuthNZ
gem 'devise', '~> 4.7.3'
gem 'omniauth-saml', '1.10.3'
# Specifying the ruby saml due to this CVE: https://github.com/advisories/GHSA-jw9c-mfg7-9rx2
gem 'ruby-saml', '~> 1.12.3'
gem 'jwt', '~> 2.2.2'

gem 'csv'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Code analysis tools
  gem 'rubocop', '= 1.11.0', require: false
  gem 'rubocop-rails', '= 2.9.1', require: false
  gem 'rubocop-checkstyle_formatter', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  # Updating selenimum webdriver which also requires rexml >= 3.2.5
  gem 'selenium-webdriver', '~> 4.0'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'minitest-reporters', '1.4.3', require: false
  gem 'simplecov', '= 0.21.2', require: false
  gem 'simplecov-rcov', '= 0.2.3', require: false
  gem 'faker', '>= 2.17.0'
  gem 'rails-controller-testing', '>= 1.0.5'
end

group :production do
  gem 'pg', '~> 1.2.3'
end

gem 'tzinfo-data', '>= 1.2016.7' # Don't rely on OSX/Linux timezone data
