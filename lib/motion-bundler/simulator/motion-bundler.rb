module Simulator
  module MotionBundler
    extend self

    def warn(*args)
      message = begin
        if args.size == 2
          method_call, caller = *args
        else
          object, method, caller = *args
          method_call = "#{object}.#{method}"
        end
        "Called `#{method_call}` from\n#{derive_caller caller}"
      end
      puts "   Warning #{message.gsub("\n", "\n           ")}".yellow
    end

  private

    def derive_caller(caller)
      [caller].flatten[0].to_s.match /^(.*\.rb):(\d+)/
      if $1
        "#{$1}:#{$2}"
      else
        "<unknown path>"
      end
    end

  end
end