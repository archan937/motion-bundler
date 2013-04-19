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
        unless Kernel.respond_to?(:require_with_hook)
          Kernel.instance_eval &require_hook
        end
        unless Object.respond_to?(:require_with_hook)
          Object.class_eval &require_hook
        end
      end

      def stop
        if Kernel.respond_to?(:require_with_hook)
          Kernel.instance_eval &require_unhook
        end
        if Object.respond_to?(:require_with_hook)
          Object.class_eval &require_unhook
        end
      end

    private

      def require_hook
        @require_hook ||= proc do
          def require_with_hook(path)
            require_without_hook path
          end
          alias :require_without_hook :require
          alias :require :require_with_hook
        end
      end

      def require_unhook
        @require_unhook ||= proc do
          alias :require :require_without_hook
          undef :require_with_hook
          undef :require_without_hook
        end
      end

    end
  end
end