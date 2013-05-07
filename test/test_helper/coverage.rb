if Dir.pwd == File.expand_path("../../..", __FILE__)
  require "simplecov"
  SimpleCov.coverage_dir "test/coverage"
  SimpleCov.start do
    # add_filter "lib/motion-bundler/simulator/core_ext.rb"
  end
end