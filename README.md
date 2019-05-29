## Ruby-Cucumber-Capybara
[![Travis Status](https://travis-ci.org/saucelabs-sample-test-frameworks/Ruby-Cucumber-Capybara.svg?branch=master)](https://travis-ci.org/saucelabs-sample-test-frameworks/Ruby-Cucumber-Capybara)

This code is provided on an "AS-IS” basis without warranty of any kind, either express or implied, including without limitation any implied warranties of condition, uninterrupted use, merchantability, fitness for a particular purpose, or non-infringement. Your tests and testing environments may require you to modify this framework. Issues regarding this framework should be submitted through GitHub. For questions regarding Sauce Labs integration, please see the Sauce Labs documentation at https://wiki.saucelabs.com/. This framework is not maintained by Sauce Labs Support.

### Environment Setup

1. Global Dependencies
    * Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
    * Or Install Ruby with [Homebrew](http://brew.sh/)
    ```
    $ brew install ruby
    ```
    * Install [Rake](http://docs.seattlerb.org/rake/)
    ```
    $ gem install rake
    ```
    * Install bundler (Sudo may be necessary)
    ```
    $ gem install bundler
    ```

2. Sauce Credentials
    * In the terminal export your Sauce Labs Credentials as environmental variables:
    ```
    $ export SAUCE_USERNAME=<your Sauce Labs username>
    $ export SAUCE_ACCESS_KEY=<your Sauce Labs access key>
    ```
    * If you are using the EU data center:
    ```
    $ export SAUCE_DATA_CENTER=EU
    ```

3. Project Dependencies
	* Install packages (Use sudo if necessary)
	```
	$ bundle install
	```

### Running Tests

* Run tests in parallel on default configuration:
	```
	$ bundle exec rake
	```
* Run in parallel on a specified configuration (see `/spec/Rakefile` for the available tasks)
	```
	$ bundle exec rake windows_10_edge
	```
* Sauce Labs Demo execution:
	```
	$ bundle exec rake sauce_demo
	```

### Watch Your Tests Run

[Sauce Labs Dashboard](https://app.saucelabs.com/dashboard)
