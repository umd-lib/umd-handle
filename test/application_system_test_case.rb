# frozen_string_literal: true

require 'test_helper'

# Base class for integration/system tests
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  Capybara.register_driver :chrome_headless do |app|
    options = ::Selenium::WebDriver::Chrome::Options.new

    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--window-size=1400,1400')

    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  driven_by :chrome_headless
end
