require "motion-bundler/require/tracer/hooks"
require "motion-bundler/require/tracer/log"

module MotionBundler
  module Require
    module Tracer
      extend self

      def log
        Thread.current[:motion_bundler_log] ||= Log.new
      end

      def start
        log.clear
        Hooks.hook
      end

      def stop
        Hooks.unhook
      end

    end
  end
end