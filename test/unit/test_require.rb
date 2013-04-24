require File.expand_path("../../test_helper", __FILE__)

module Unit
  class TestRequire < MiniTest::Unit::TestCase

    describe MotionBundler::Require do
      it "should be able to trace requirements within a block" do
        object = mock "object"
        object.expects :do_something

        MotionBundler::Require::Tracer.expects :start
        MotionBundler::Require::Tracer.expects :stop

        MotionBundler::Require.trace do
          object.do_something
        end
      end

      it "should determine RubyMotion app 'default files'" do
        MotionBundler.expects(:simulator?).returns(true)
        assert_equal [File.expand_path("../../../lib/motion-bundler/simulator/core_ext.rb", __FILE__)], MotionBundler::Require.default_files
        MotionBundler.expects(:simulator?).returns(false)
        assert_equal [File.expand_path("../../../lib/motion-bundler/device/core_ext.rb", __FILE__)], MotionBundler::Require.default_files
      end
    end

  end
end