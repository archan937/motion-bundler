require "motion-bundler/core_ext"
require "motion-bundler/gem_ext"
require "motion-bundler/require"
require "motion-bundler/version"

module MotionBundler
  extend self

  def setup
    trace_require do
      Bundler.require :motion
      default_files.each do |file|
        require file
      end
      yield if block_given?
    end
  end

  def trace_require
    Require.trace do
      yield
    end
    Motion::Project::App.setup do |app|
      app.files = begin
        Require.files + app.files - ["BUNDLER", __FILE__]
      end
      app.files_dependencies(
        Require.files_dependencies.tap do |dependencies|
          (dependencies.delete("BUNDLER") || []).each do |file|
            dependencies[file] ||= []
            dependencies[file] = default_files + dependencies[file]
          end
          dependencies.delete(__FILE__)
        end
      )
    end
  end

  def simulator?
    !device?
  end

  def device?
    argv.include? "device"
  end

  def default_files
    [File.expand_path("../motion-bundler/#{simulator? ? "simulator" : "device"}/core_ext.rb", __FILE__)]
  end

private

  def argv
    ARGV
  end

end