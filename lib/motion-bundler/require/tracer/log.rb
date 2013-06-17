require "yaml"

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
          return if !file.match(/^([A-Z]+)$/) && !file.match(/^(.*\.rb):(\d+)/)

          file = $1.include?("/bundler/") ? "BUNDLER" : $1
          line = $1.include?("/bundler/") ? nil : $2

          (@requires[[file, line].compact.join(":")] ||= []) << path
          dependencies = (@files_dependencies[file] ||= [])
          index = dependencies.size

          if yield
            loaded_feature = loaded_features.last
            @files << file unless @files.include? file
            @files << loaded_feature
            dependencies.insert index, loaded_feature
          else
            @files_dependencies.delete file if dependencies.empty?
            if file.match(/^([A-Z]+)$/)
              if $CLI
                ripper = Require::Ripper.new [path], "/"
                merge! ripper.files, ripper.files_dependencies, ripper.requires
              else
                tracer = YAML.load `motion-bundler trace #{path}`
                merge! *tracer.values_at("FILES", "FILES_DEPENDENCIES", "REQUIRES")
              end
            end
          end

          true
        end

        def merge!(files, files_dependencies, requires)
          @files.merge files
          files_dependencies.each do |file, dependencies|
            (@files_dependencies[file] ||= []).concat dependencies
          end
          requires.each do |file, paths|
            (@requires[file] ||= []).concat paths
          end
        end

      private

        def loaded_features
          $LOADED_FEATURES
        end

      end
    end
  end
end