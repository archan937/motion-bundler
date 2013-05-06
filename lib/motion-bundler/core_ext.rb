module Kernel
  def trace_require
    MotionBundler.trace_require do
      yield
    end
  end
end