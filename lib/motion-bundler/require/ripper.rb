require "motion-bundler/require/ripper/builder"

module MotionBundler
  module Require
    class Ripper

      def initialize(*sources)
        @sources = sources
        parse
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

      def parse
        @log = {}
        @requires = {}
        @sources.each do |source|
          builder = Builder.new source
          builder.requires.each do |method, args|
            (@log[source] ||= []) << begin
              method == :require_relative ? File.expand_path("../#{args[0]}.rb", source) : Require.resolve(args[0])
            end
            (@requires[source] ||= []) << args[0]
          end
        end
      end

    end
  end
end