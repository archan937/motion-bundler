require "motion-bundler/require/mocker/hooks"
require "motion-bundler/require/mocker/dirs"

module MotionBundler
  module Require
    module Mocker
      include Hooks
      include Dirs
      extend self

      def yield
        start
        yield
      ensure
        stop
      end

    private

      def start
        hook
      end

      def stop
        unhook
      end

    end
  end
end