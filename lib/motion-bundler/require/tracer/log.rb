module MotionBundler
  module Require
    module Tracer
      class Log

        def initialize
          @files = Set.new
          @files_dependencies = {}
          @requires = {}
        end

        def clear
          @files.clear
          @files_dependencies.clear
          @requires.clear
        end

        def files
          @files.to_a
        end

        def files_dependencies
          @files_dependencies.dup
        end

        def requires
          @requires.dup
        end

        def register(file, path)
          return unless file.match(/^(.*\.rb):(\d+)/) || file.match(/^([A-Z]+)$/)

          file = $1.include?("/bundler/") ? "BUNDLER" : $1
          line = $1.include?("/bundler/") ? nil : $2

          (@requires[[file, line].compact.join(":")] ||= []) << path
          dependencies = (@files_dependencies[file] ||= [])
          index = dependencies.size

          loaded_feature = begin
            if (result = yield).is_a?(Hash)
              result[:required]
            else
              loaded_features.last
            end
          end

          if loaded_feature
            @files << file unless @files.include? file
            @files << loaded_feature
            dependencies.insert index, loaded_feature
          else
            @files_dependencies.delete file if dependencies.empty?
          end

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