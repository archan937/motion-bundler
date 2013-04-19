require File.expand_path("../../test_helper", __FILE__)

module Unit
  class TestRequire < MiniTest::Unit::TestCase

    describe MotionBundler do
      it "should be able to trace requirements within a block" do
        object = mock "object"
        object.expects :do_something

        MotionBundler::Require::Tracer.expects :start
        MotionBundler::Require::Tracer.expects :stop

        MotionBundler::Require.trace do
          object.do_something
        end
      end
    end

  end
end