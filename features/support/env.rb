# frozen_string_literal: true

require 'capybara/cucumber'
require 'selenium-webdriver'
require 'sauce_whisk'

Before do |scenario|
  Capybara.register_driver :sauce do |app|
    options = platform("#{scenario.feature.name} - #{scenario.name}")

    browser = options.delete(:browser_name).to_sym
    caps = Selenium::WebDriver::Remote::Capabilities.send(browser, options)

    Capybara::Selenium::Driver.new(app, browser: :remote,
                                        url: sauce_url,
                                        desired_capabilities: caps)
  end
  Capybara.current_driver = :sauce
end

After do |scenario|
  session_id = Capybara.current_session.driver.browser.session_id
  SauceWhisk.data_center = "#{sauce_data_center}_VDC".to_sym
  SauceWhisk::Jobs.change_status(session_id, scenario.passed?)
  Capybara.current_session.quit
end

#
# Note that having this as a conditional in the test code is less ideal
# It is better for static data to be pulled from a serialized file like a yaml
#
# Note: not all browsers are defaulting to using w3c protocol
# This will change soon. Where possible prefer the w3c approach
#
def platform(name)
  case ENV['PLATFORM']
  when 'windows_10_edge'
    {platform_name: 'Windows 10',
     browser_name: 'edge',
     browser_version: '18.17763'}.merge(sauce_w3c(name))
  when 'windows_8_ie'
    {platform: 'Windows 8.1',
     browser_name: 'ie',
     version: '11.0'}.merge(sauce_w3c(name))
  when 'mac_sierra_chrome'
    # This is for running Chrome with w3c which is not yet the default
    {platform_name: 'macOS 10.12',
     browser_name: 'chrome',
     "goog:chromeOptions": {w3c: true},
     browser_version: '65.0'}.merge(sauce_w3c(name))
  when 'mac_mojave_safari'
    {platform_name: 'macOS 10.14',
     browser_name: 'safari',
     browser_version: '12.0'}.merge(sauce_w3c(name))
  when 'windows_7_ff'
    {platform_name: 'Windows 7',
     browser_name: 'firefox',
     browser_version: '60.0'}.merge(sauce_w3c(name))
  else
    # Always specify a default;
    # this doesn't force Chrome to w3c
    {platform: 'macOS 10.12',
     browser_name: 'chrome',
     version: '65.0'}.merge(sauce_oss(name))
  end
end

def sauce_w3c(name)
  {'sauce:options' => {name: name,
                       build: build_name,
                       username: ENV['SAUCE_USERNAME'],
                       access_key: ENV['SAUCE_ACCESS_KEY'],
                       iedriver_version: '3.141.59',
                       selenium_version: '3.141.59'}}
end

def sauce_oss(name)
  {name: name,
   build: build_name,
   username: ENV['SAUCE_USERNAME'],
   access_key: ENV['SAUCE_ACCESS_KEY'],
   selenium_version: '3.141.59'}
end

def sauce_data_center
  ENV.fetch('SAUCE_DATA_CENTER', 'US')
end

def sauce_url
  {
    'US' => 'https://ondemand.saucelabs.com:443/wd/hub',
    'EU' => 'https://ondemand.eu-central-1.saucelabs.com/wd/hub'
  }.fetch(sauce_data_center)
end

#
# Note that this build name is specifically for Travis CI execution
# Most CI tools have ENV variables that can be structured to provide useful build names
#
def build_name
  if ENV['TRAVIS_REPO_SLUG']
    "#{ENV['TRAVIS_REPO_SLUG'][%r{[^/]+$}]}: #{ENV['TRAVIS_JOB_NUMBER']}"
  elsif ENV['SAUCE_START_TIME']
    ENV['SAUCE_START_TIME']
  else
    "Ruby-Cucumber-Capybara: Local-#{Time.now.to_i}"
  end
end
