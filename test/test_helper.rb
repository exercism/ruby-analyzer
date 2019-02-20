gem 'minitest'

require "minitest/autorun"
require 'minitest/pride'
require "mocha/setup"

class Minitest::Test
  SAFE_WRITE_PATH = Pathname.new('/tmp')
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "analyzer"
