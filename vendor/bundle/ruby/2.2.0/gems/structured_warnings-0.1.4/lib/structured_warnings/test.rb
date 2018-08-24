require "structured_warnings/test/warner"
require "structured_warnings/test/assertions"

Test::Unit::TestCase.class_eval do
  include StructuredWarnings::Test::Assertions
end
