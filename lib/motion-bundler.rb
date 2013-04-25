require "motion-bundler/gem_ext"
require "motion-bundler/require"
require "motion-bundler/version"

module MotionBundler
  extend self

  def setup
    trace_require do
      Bundler.require :motion
      yield if block_given?
    end
  end

  def trace_require
    Require.trace do
      yield
    end
    Motion::Project::App.setup do |app|
      app.files = Require.files + app.files
      app.files_dependencies Require.files_dependencies
    end
  end

  def simulator?
    !device?
  end

  def device?
    argv.include? "device"
  end

private

  def argv
    ARGV
  end

end