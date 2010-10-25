require "table_for"
require "webrat"

RSpec.configure do |config|
  config.include(Webrat::Matchers)
end
