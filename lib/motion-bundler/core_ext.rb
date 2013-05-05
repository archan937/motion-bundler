module Kernel
  def trace_require
    MotionBundler.trace_require do
      yield
    end
  end
  def trace_require?
    Kernel.respond_to? :require_with_mb_trace
  end
end