require "table_for_collection"
require "webrat"

RSpec.configure do |config|
  config.include(Webrat::Matchers)
end
