module MotionBundler
  module Require
    module Tracer
      module Hooks

        def hook
          Kernel.instance_eval &require_hook          unless Kernel.respond_to?(:require_with_mb_trace)
          Object.class_eval    &require_hook          unless Object.respond_to?(:require_with_mb_trace)
          Kernel.instance_eval &require_relative_hook unless Kernel.respond_to?(:require_relative_with_mb_trace)
          Object.class_eval    &require_relative_hook unless Object.respond_to?(:require_relative_with_mb_trace)
          Kernel.instance_eval &load_hook             unless Kernel.respond_to?(:load_with_mb_trace)
          Object.class_eval    &load_hook             unless Object.respond_to?(:load_with_mb_trace)
          Module.class_eval    &autoload_hook         unless Module.respond_to?(:autoload_with_mb_trace)
        end

        def unhook
          Kernel.instance_eval &require_unhook          if Kernel.respond_to?(:require_with_mb_trace)
          Object.class_eval    &require_unhook          if Object.respond_to?(:require_with_mb_trace)
          Kernel.instance_eval &require_relative_unhook if Kernel.respond_to?(:require_relative_with_mb_trace)
          Object.class_eval    &require_relative_unhook if Object.respond_to?(:require_relative_with_mb_trace)
          Kernel.instance_eval &load_unhook             if Kernel.respond_to?(:load_with_mb_trace)
          Object.class_eval    &load_unhook             if Object.respond_to?(:load_with_mb_trace)
          Module.class_eval    &autoload_unhook         if Module.respond_to?(:autoload_with_mb_trace)
        end

      private

        def require_hook
          @require_hook ||= proc do
            def require_with_mb_trace(path, _caller = nil, _path = nil)
              result = nil
              MotionBundler::Require::Tracer.log.register(_caller || caller[0], _path || path) do
                unless result = require_without_mb_trace(path)
                  {:required => MotionBundler::Require.resolve(path, false)}
                end
              end
              result
            end
            alias :require_without_mb_trace :require
            alias :require :require_with_mb_trace
          end
        end

        def require_relative_hook
          @require_relative_hook ||= proc do
            def require_relative_with_mb_trace(path)
              caller[0].match(/^(.*\.rb)\b/)
              require_with_mb_trace File.expand_path("../#{path}", $1), caller[0], path
            end
            alias :require_relative_without_mb_trace :require_relative
            alias :require_relative :require_relative_with_mb_trace
          end
        end

        def load_hook
          @load_hook ||= proc do
            def load_with_mb_trace(path)
              require_with_mb_trace path, caller[0]
            end
            alias :load_without_mb_trace :load
            alias :load :load_with_mb_trace
          end
        end

        def autoload_hook
          @autoload_hook ||= proc do
            def autoload_with_mb_trace(mod, filename)
              require_with_mb_trace filename, caller[0]
            end
            alias :autoload_without_mb_trace :autoload
            alias :autoload :autoload_with_mb_trace
          end
        end

        def require_unhook
          @require_unhook ||= proc do
            alias :require :require_without_mb_trace
            undef :require_with_mb_trace
            undef :require_without_mb_trace
          end
        end

        def require_relative_unhook
          @require_relative_unhook ||= proc do
            alias :require_relative :require_relative_without_mb_trace
            undef :require_relative_with_mb_trace
            undef :require_relative_without_mb_trace
          end
        end

        def load_unhook
          @load_unhook ||= proc do
            alias :load :load_without_mb_trace
            undef :load_with_mb_trace
            undef :load_without_mb_trace
          end
        end

        def autoload_unhook
          @autoload_unhook ||= proc do
            alias :autoload :autoload_without_mb_trace
            undef :autoload_with_mb_trace
            undef :autoload_without_mb_trace
          end
        end

      end
    end
  end
end