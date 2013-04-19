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

          dependencies = (@log[$1] ||= [])
          dindex = dependencies.size
          findex = loaded_features.size

          yield

          dependencies.insert dindex, loaded_features[findex]
          true
        end

      private

        def loaded_features
          $LOADED_FEATURES
        end

      end
    end
  end
end