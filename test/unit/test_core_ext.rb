require File.expand_path("../../test_helper", __FILE__)

module Unit
  class TestCoreExt < MiniTest::Unit::TestCase

    describe "lib/motion-bundler/core_ext.rb" do
      it "should delegate trace_require to MotionBundler" do
        object = mock "object"

        object.expects :do_something
        Kernel.trace_require do
          object.do_something
          assert_equal true, Kernel.trace_require?
        end
        assert_equal false, Kernel.trace_require?

        object.expects :do_something
        trace_require do
          object.do_something
          assert_equal true, trace_require?
        end
        assert_equal false, trace_require?

        MotionBundler.expects(:trace_require)
        Kernel.trace_require

        MotionBundler.expects(:trace_require)
        trace_require
      end
    end

  end
end