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
      app.files = Require::Tracer.log.files + app.files
      app.files_dependencies Require::Tracer.log.files_dependencies.tap{|x| x.delete "BUNDLER"}
    end
  end

end