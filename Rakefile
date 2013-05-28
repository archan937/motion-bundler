#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rake/testtask"

task :default => "test/unit"

Rake::TestTask.new("test/unit") do |t|
  t.test_files = FileList["test/unit/**/test_*.rb"]
end
task("test/unit").clear_comments
task("test/unit").comment = "Run unit tests"

desc "Run motion tests (Usage: .rake)"
task "test/motion" do
  if ENV["BUNDLE_GEMFILE"] == "foo"
    FileList["test/motion/**/test_*.rb"].each_with_index do |test_file, index|
      puts if index > 0 || ARGV.include?("test/unit")
      puts "\e[0;32;49m#{test_file}:\n\e[0m"
      test_file = File.expand_path test_file
      system "cd #{File.dirname test_file} && ruby #{File.basename test_file}"
    end
  else
    puts "\e[0;31;49mPlease use `.rake` to run motion tests\e[0m"
  end
end