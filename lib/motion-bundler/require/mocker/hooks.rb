module MotionBundler
  module Require
    module Mocker
      module Hooks

        def hook
          Kernel.instance_eval &require_hook unless Kernel.respond_to?(:require_with_mb_mock)
          Object.class_eval    &require_hook unless Object.respond_to?(:require_with_mb_mock)
        end

        def unhook
          Kernel.instance_eval &require_unhook if Kernel.respond_to?(:require_with_mb_mock)
          Object.class_eval    &require_unhook if Object.respond_to?(:require_with_mb_mock)
        end

      private

        def require_hook
          @require_hook ||= proc do
            def require_with_mb_mock(path)
              require_without_mb_mock MotionBundler::Require::Mocker.resolve(path)
            end
            alias :require_without_mb_mock :require
            alias :require :require_with_mb_mock
          end
        end

        def require_unhook
          @require_unhook ||= proc do
            alias :require :require_without_mb_mock
            undef :require_with_mb_mock
            undef :require_without_mb_mock
          end
        end

      end
    end
  end
end