$:.unshift File.expand_path("../lib", __FILE__)
$:.unshift File.expand_path("../../lib", __FILE__)

if Dir.pwd == File.expand_path("../..", __FILE__)
  require "simplecov"
  SimpleCov.coverage_dir "test/coverage"
  SimpleCov.start
end

require "fileutils"
require "minitest/unit"
require "minitest/autorun"
require "mocha/setup"
require "motion-bundler"

def motion_gemfile(content)
  content = "source \"https://rubygems.org\"\n\n#{content}"
  dirname = File.dirname __FILE__

  gemfile = begin
    File.expand_path(caller[0]).match /^(.*)\.rb\b/
    $1.gsub "#{dirname}/motion", "#{dirname}/.gemfiles"
  end
  lockfile = "#{gemfile}.lock"

  if !File.exists?(gemfile) || File.read(gemfile) != content
    FileUtils.mkdir_p File.dirname(gemfile)
    File.open(gemfile, "w"){|f| f.write content}
    File.delete(lockfile) if File.exists?(lockfile)
  end

  unless File.exists?(lockfile)
    puts "Running `bundle install` for #{gemfile.gsub("#{dirname}/", "")}\n\n"
    `cd #{File.dirname gemfile} && bundle install --gemfile=#{gemfile} --quiet`
  end

  ENV["BUNDLE_GEMFILE"] = gemfile
  require "bundler"
end