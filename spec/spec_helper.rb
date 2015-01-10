require "bundler"
Bundler.require :default, :test, :development
require "direction"
Dir["./spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rr
end
