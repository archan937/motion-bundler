if Dir.pwd == File.expand_path("../..", __FILE__)
  require "simplecov"
  SimpleCov.start
end

require "minitest/unit"
require "minitest/autorun"
require "mocha/setup"

require "motion-bundler"
$:.unshift File.expand_path("../lib", __FILE__)