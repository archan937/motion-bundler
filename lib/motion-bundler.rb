require "motion-bundler/require"
require "motion-bundler/version"

module MotionBundler
  extend self

  def setup
    MotionBundler::Require.trace do
      Bundler.require :motion
      yield if block_given?
    end
  end

end