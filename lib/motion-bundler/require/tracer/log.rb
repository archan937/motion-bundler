module MotionBundler
  module Require
    module Tracer
      class Log

        def initialize
          @log = {}
          @requires = {}
        end

        def clear
          @log.clear
          @requires.clear
        end

        def register(file, path)
          return unless file.match(/^(.*\.rb):(\d+)/) || file.match(/^([A-Z]+)$/)

          file = $1.include?("/bundler/") ? "BUNDLER" : $1
          line = $1.include?("/bundler/") ? nil : $2

          (@requires[[file, line].compact.join(":")] ||= []) << path
          dependencies = (@log[file] ||= [])
          index = dependencies.size

          loaded_feature = begin
            if (result = yield).is_a?(Hash)
              result[:required]
            else
              loaded_features.last
            end
          end

          if loaded_feature
            dependencies.insert index, loaded_feature
          else
            @log.delete file if dependencies.empty?
          end

          true
        end

        def files
          (@log.keys + @log.values).flatten.sort.uniq
        end

        def files_dependencies
          @log.dup
        end

        def requires
          @requires.dup
        end

      private

        def loaded_features
          $LOADED_FEATURES
        end

      end
    end
  end
end