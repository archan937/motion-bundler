require "motion-bundler/require/tracer"
require "motion-bundler/require/mocker"
require "motion-bundler/require/ripper"
require "motion-bundler/require/resolve"

module MotionBundler
  module Require
    include Resolve
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

    def requires
      Tracer.log.requires
    end

  end
end