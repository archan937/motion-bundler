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
        @log ||= {}
        @requires ||= {}
        @sources.each do |source|
          next if @log.include?(source)
          added_sources = []

          builder = Builder.new source
          builder.requires.each do |method, args|
            (@log[source] ||= []) << begin
              (method == :require_relative ? File.expand_path("../#{args[0]}.rb", source) : Require.resolve(args[0])).tap do |file|
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