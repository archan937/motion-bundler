require "motion-bundler/require/mocker/hooks"
require "motion-bundler/require/mocker/paths"

module MotionBundler
  module Require
    module Mocker
      include Hooks
      include Paths
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