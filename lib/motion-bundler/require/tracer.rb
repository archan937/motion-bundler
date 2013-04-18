require "motion-bundler/require/tracer/log"

module MotionBundler
  module Require
    module Tracer
      extend self

      def log
        Thread.current[:motion_bundler_log] ||= Log.new
      end

      def start
        log
      end

      def stop
      end

    end
  end
end