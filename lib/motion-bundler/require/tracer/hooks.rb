module MotionBundler
  module Require
    module Tracer
      module Hooks
        extend self

        def hook
          Kernel.instance_eval &require_hook unless Kernel.respond_to?(:require_with_hook)
          Object.class_eval    &require_hook unless Object.respond_to?(:require_with_hook)
        end

        def unhook
          Kernel.instance_eval &require_unhook if Kernel.respond_to?(:require_with_hook)
          Object.class_eval    &require_unhook if Object.respond_to?(:require_with_hook)
        end

      private

        def require_hook
          @require_hook ||= proc do
            def require_with_hook(path)
              result = nil
              MotionBundler::Require::Tracer.log.register caller[0] do
                result = require_without_hook path
              end
              result
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
end