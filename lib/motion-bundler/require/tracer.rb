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
        log.clear
        hook
      end

      def stop
        unhook
      end

    end
  end
end