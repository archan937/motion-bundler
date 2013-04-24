require "motion-bundler/require/tracer"

module MotionBundler
  module Require
    extend self

    def default_files
      [File.expand_path("../#{MotionBundler.simulator? ? "simulator" : "device"}/core_ext.rb", __FILE__)]
    end

    def trace
      Tracer.start
      yield if block_given?
      Tracer.stop
    end

  end
end