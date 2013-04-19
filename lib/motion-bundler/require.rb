require "motion-bundler/require/tracer"

module MotionBundler
  module Require
    extend self

    def trace
      Tracer.start
      yield
      Tracer.stop
    end

  end
end