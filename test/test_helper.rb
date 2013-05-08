$:.unshift File.expand_path("../lib", __FILE__)
$:.unshift File.expand_path("../../lib", __FILE__)

require_relative "test_helper/coverage"
require_relative "test_helper/motion"

require "fileutils"
require "minitest/unit"
require "minitest/autorun"
require "mocha/setup"
require "motion-bundler"

class MiniTest::Unit::TestCase
  def setup
    ENV["MB_SILENCE_CORE"] = "false"
  end
  def teardown
    if File.exists?(file = MotionBundler::MOTION_BUNDLER_FILE)
      File.delete file
    end
  end
end

def motion_bundler_file(path)
  File.expand_path "../../lib/#{path}", __FILE__
end

def gem_path(name)
  File.expand_path "../gems/#{name}", __FILE__
end

def lib_file(path)
  File.expand_path "../lib/#{path}", __FILE__
end

def mocks_dir
  File.expand_path "../mocks", __FILE__
end

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
  Bundler.setup
end

def taintable_core
  Kernel.instance_eval do
    alias :_ruby_require :require
    alias :_ruby_require_relative :require_relative
    alias :_ruby_load :load
    alias :_ruby_autoload :autoload
  end
  Module.class_eval do
    alias :_ruby_autoload :autoload
    alias :_ruby_class_eval :class_eval
    alias :_ruby_module_eval :module_eval
  end
  Object.class_eval do
    alias :_ruby_require :require
    alias :_ruby_instance_eval :instance_eval
  end
  yield
ensure
  Kernel.instance_eval do
    alias :require :_ruby_require
    alias :require_relative :_ruby_require_relative
    alias :load :_ruby_load
    alias :autoload :_ruby_autoload
    undef :_ruby_require
    undef :_ruby_require_relative
    undef :_ruby_load
    undef :_ruby_autoload
    undef :console if respond_to?(:console)
  end
  Module.class_eval do
    alias :autoload :_ruby_autoload
    alias :class_eval :_ruby_class_eval
    alias :module_eval :_ruby_module_eval
    undef :_ruby_autoload
    undef :_ruby_class_eval
    undef :_ruby_module_eval
  end
  Object.class_eval do
    alias :require :_ruby_require
    alias :instance_eval :_ruby_instance_eval
    undef :_ruby_require
    undef :_ruby_instance_eval
  end
end