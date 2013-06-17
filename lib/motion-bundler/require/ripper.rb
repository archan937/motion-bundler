require "set"
require "motion-bundler/require/ripper/builder"

module MotionBundler
  module Require
    class Ripper

      def initialize(sources, scope = MotionBundler::PROJECT_PATH)
        @sources = sources
        @scope = scope
        @files = Set.new
        @files_dependencies = {}
        @requires = {}
        parse
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

    private

      def parse
        @sources.each do |source|
          next if @requires.include?(source)
          added_sources = []

          builder = Builder.new source
          builder.requires.each do |method, args|

            (@requires[source] ||= []) << args[0]
            ((arg = args[0]).include?("*.rb") ? Dir[arg] : [arg]).each do |file|
              file = begin
                if method == :require_relative
                  File.expand_path("../#{file}.rb", source)
                else
                  Require.resolve(file, false)
                end
              end

              @files << source
              @files << file

              (@files_dependencies[source] ||= []) << file
              expanded_path = File.expand_path(file)

              unless @sources.any?{|x| File.expand_path(x) == expanded_path}
                if expanded_path.match(/^#{@scope}/)
                  added_sources << file
                else
                  MotionBundler.app_require file
                end
              end
            end
          end

          unless added_sources.empty?
            @sources.concat added_sources
            parse
            return
          end
        end
      end

    end
  end
end