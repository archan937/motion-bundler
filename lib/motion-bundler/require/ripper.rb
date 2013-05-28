require "set"
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
            (@requires[source] ||= []) << args[0]

            file = begin
              if method == :require_relative
                File.expand_path("../#{args[0]}.rb", source)
              else
                Require.resolve(args[0])
              end
            end

            next if @sources.any?{|x| File.expand_path(x) == File.expand_path(file)}

            if file.include?(File.expand_path("."))
              added_sources << file
            else
              MotionBundler.app_require file
            end

            @files << source
            @files << file

            (@files_dependencies[source] ||= []) << file
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