require File.expand_path("../../test_helper", __FILE__)

module Unit
  class TestRequire < MiniTest::Unit::TestCase

    describe MotionBundler do
      it "should be able to trace requirements within a block" do
        MotionBundler::Require::Tracer.expects(:start)
        MotionBundler::Require::Tracer.expects(:stop)
        MotionBundler::Require.trace {}
      end
    end

  end
end