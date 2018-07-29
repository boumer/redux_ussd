require 'bundler/setup'
require 'redux_ussd'
require 'coveralls'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  SimpleCov.start do
    add_filter "/spec/"
    add_filter "/vendor/"
  end
  Coveralls.wear!
end
