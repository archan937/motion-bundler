require "motion-bundler/gem_ext"
require "motion-bundler/require"
require "motion-bundler/version"

module MotionBundler
  extend self

  def setup
    Require.trace do
      Bundler.require :motion
      yield if block_given?
    end
    Motion::Project::App.setup do |app|
      app.files = Require::Tracer.log.files + app.files - ["BUNDLER"]
      app.files_dependencies Require::Tracer.log.files_dependencies.tap{|x| x.delete "BUNDLER"}
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