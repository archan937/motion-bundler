require File.expand_path("../../test_helper", __FILE__)

module Unit
  class TestRequire < MiniTest::Unit::TestCase

    describe MotionBundler::Require do
      it "should be able to mock and trace requirements within a block" do
        object = mock "object"
        object.expects :do_something

        MotionBundler::Require.mock_and_trace do
          object.do_something
        end

        MotionBundler::Require::Tracer.expects :yield
        MotionBundler::Require.mock_and_trace do
        end

        MotionBundler::Require::Mocker.expects :yield
        MotionBundler::Require.mock_and_trace do
        end
      end

      it "should be able to trace requirements within a block" do
        object = mock "object"
        object.expects :do_something

        MotionBundler::Require.trace do
          object.do_something
        end

        MotionBundler::Require::Tracer.expects :yield
        MotionBundler::Require.trace do
        end
      end

      it "should be able to mock requirements within a block" do
        object = mock "object"
        object.expects :do_something

        MotionBundler::Require.mock do
          object.do_something
        end

        MotionBundler::Require::Mocker.expects :yield
        MotionBundler::Require.mock do
        end
      end

      it "should return log files, files_dependencies and requires" do
        MotionBundler::Require::Tracer.log.expects(:files)
        MotionBundler::Require.files

        MotionBundler::Require::Tracer.log.expects(:files_dependencies)
        MotionBundler::Require.files_dependencies

        MotionBundler::Require::Tracer.log.expects(:requires)
        MotionBundler::Require.requires
      end
    end

  end
end