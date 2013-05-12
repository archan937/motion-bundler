require "motion-bundler/require/ripper/builder"

module MotionBundler
  module Require
    class Ripper

      def initialize(*sources)
        @sources = sources
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
          next if @files_dependencies.include?(source)
          added_sources = []

          builder = Builder.new source
          builder.requires.each do |method, args|
            (@files_dependencies[source] ||= []) << begin
              (method == :require_relative ? File.expand_path("../#{args[0]}.rb", source) : Require.resolve(args[0])).tap do |file|
                @files << source
                @files << file
                unless @sources.any?{|x| File.expand_path(x) == File.expand_path(file)}
                  if file.include?(File.expand_path("."))
                    added_sources << file
                  else
                    MotionBundler.app_require file
                  end
                end
              end
            end
            (@requires[source] ||= []) << args[0]
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