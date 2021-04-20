require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UmdHandle
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # The secret used to generate JWT tokens
    # Any value can be used as long as it is "sufficiently long",
    # such as by running the following command in the console:
    #     uuidgen | shasum -a256 | cut -d' ' -f1
    config.jwt_secret=ENV['JWT_SECRET']

    # The base URL (including a trailing slash) for the handle proxy server
    # associated with this application.
    # For example: "https://hdl-test.lib.umd.edu/"
    config.handle_http_proxy_base=ENV['HANDLE_HTTP_PROXY_BASE']

    # Configure the hostname, when HOST is provided.
    # Note: A HOST environment variable (typically provided by a ".env" file)
    # is REQUIRED when running the application on a server.
    #
    # It is not strictly required, because that causes other processes that
    # don't require a HOST (such as performing the tests, or database
    # migrations) to fail.
    #
    # HOST should be ignored (and config.hosts not set) when running the tests.
    if ENV['HOST'].present? && !Rails.env.test?
      config.hosts << /\A10\.\d+\.\d+\.\d+\z/
      config.hosts << ENV['HOST']
      config.action_mailer.default_url_options = { host: ENV['HOST'] }
    end
  end
end
