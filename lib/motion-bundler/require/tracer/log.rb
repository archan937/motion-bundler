module MotionBundler
  module Require
    module Tracer
      class Log

        def initialize
          @log = {}
        end

        def clear
          @log.clear
        end

        def register(file)
          return unless file.match(/^(.*\.rb)\b/)

          file = $1.include?("/bundler/") ? "BUNDLER" : $1
          dependencies = (@log[file] ||= [])
          index = dependencies.size

          yield

          dependencies.insert index, loaded_features.last
          true
        end

        def files
          (@log.keys + @log.values).flatten.sort.uniq
        end

        def files_dependencies
          @log.dup
        end

      private

        def loaded_features
          $LOADED_FEATURES
        end

      end
    end
  end
end