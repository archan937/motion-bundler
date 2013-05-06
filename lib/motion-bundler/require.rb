require "motion-bundler/require/tracer"
require "motion-bundler/require/mocker"

module MotionBundler
  module Require
    extend self

    def trace
      Tracer.yield do
        yield
      end
    end

    def mock
      Mocker.yield do
        yield
      end
    end

    def files
      Tracer.log.files
    end

    def files_dependencies
      Tracer.log.files_dependencies
    end

  end
end