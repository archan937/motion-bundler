require File.expand_path("../../test_helper", __FILE__)
require "bundler"

module Unit
  class TestMotionBundler < MiniTest::Unit::TestCase

    describe MotionBundler do
      it "should distinguish whether compiling for simulator or device" do
        assert_equal ARGV, MotionBundler.send(:argv)

        MotionBundler.expects(:argv).twice.returns %w()
        assert_equal true, MotionBundler.simulator?
        assert_equal false, MotionBundler.device?

        MotionBundler.expects(:argv).twice.returns %w(device)
        assert_equal false, MotionBundler.simulator?
        assert_equal true, MotionBundler.device?
      end

      it "should require the :motion Bundler group and trace when invoking setup" do
        object = mock "object"
        object.expects :do_something

        Bundler.expects(:require).with(:motion)
        MotionBundler.setup do
          object.do_something
        end

        MotionBundler.expects(:trace_require)
        MotionBundler.setup
      end

      it "should require, trace and register files and files dependencies" do
        object = mock "object"
        object.expects :do_something

        MotionBundler.trace_require do
          object.do_something
        end

        MotionBundler::Require.expects :trace
        Motion::Project::App.any_instance.expects :files=
        Motion::Project::App.any_instance.expects :files_dependencies
        MotionBundler.setup
      end
    end

  end
end