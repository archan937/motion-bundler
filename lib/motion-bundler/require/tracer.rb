require "motion-bundler/require/tracer/hooks"
require "motion-bundler/require/tracer/log"

module MotionBundler
  module Require
    module Tracer
      include Hooks
      extend self

      def log
        Thread.current[:motion_bundler_log] ||= Log.new
      end

      def yield
        start
        yield
      ensure
        stop
      end

    private

      def start
        ENV["MB_SILENCE_CORE"] = "false"
        log.clear
        hook
      end

      def stop
        ENV["MB_SILENCE_CORE"] = "true"
        unhook
      end

    end
  end
end