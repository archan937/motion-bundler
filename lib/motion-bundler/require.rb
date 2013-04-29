require "motion-bundler/require/tracer"

module MotionBundler
  module Require
    extend self

    def default_files
      [File.expand_path("../#{MotionBundler.simulator? ? "simulator" : "device"}/core_ext.rb", __FILE__)]
    end

    def trace
      Tracer.start
      yield
      Tracer.stop
    end

    def files
      default_files + Tracer.log.files - ["BUNDLER"]
    end

    def files_dependencies
      Tracer.log.files_dependencies.tap do |dependencies|
        (dependencies.delete("BUNDLER") || []).each do |file|
          dependencies[file] ||= []
          dependencies[file] = default_files + dependencies[file]
        end
      end
    end

  end
end