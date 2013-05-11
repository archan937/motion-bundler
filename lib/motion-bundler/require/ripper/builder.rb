require "ripper"

module MotionBundler
  module Require
    class Ripper
      class Builder < ::Ripper::SexpBuilder

        def initialize(file)
          super File.read(file)
        end

        def requires
          @requires || begin
            @requires = []
            parse
            @requires
          end
        end

      private

        def on_command(command, args)
          type, name, position = command
          if %w(require require_relative).include? name
            @requires << [name.to_sym, extract_arguments(args)]
          end
        end

        def extract_arguments(args)
          args.inject([]) do |result, arg|
            if arg.is_a?(Array)
              if arg[0] == :@tstring_content
                result << arg[1]
              else
                result.concat extract_arguments(arg)
              end
            end
            result
          end
        end

      end
    end
  end
end