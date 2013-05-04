require File.expand_path("../../test_helper", __FILE__)

module Unit
  class TestRequire < MiniTest::Unit::TestCase

    describe MotionBundler::Require do
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

      it "should determine RubyMotion app 'default files'" do
        MotionBundler.expects(:simulator?).returns(true)
        assert_equal [lib_file("motion-bundler/simulator/core_ext.rb")], MotionBundler::Require.default_files

        MotionBundler.expects(:simulator?).returns(false)
        assert_equal [lib_file("motion-bundler/device/core_ext.rb")], MotionBundler::Require.default_files
      end

      it "should consolidate files and files_dependencies" do
        MotionBundler::Require::Tracer.log.instance_variable_set :@log, {
          "BUNDLER" => %w(file1),
          "/Sources/lib/file1.rb" => %w(file0 file2),
          "/Sources/lib/file2.rb" => %w(file3 file4)
        }

        assert_equal [
          lib_file("motion-bundler/simulator/core_ext.rb")
        ] + %w(/Sources/lib/file1.rb /Sources/lib/file2.rb file0 file1 file2 file3 file4), MotionBundler::Require.files
        assert_equal({
          "file1" => [lib_file("motion-bundler/simulator/core_ext.rb")],
          "/Sources/lib/file1.rb" => %w(file0 file2),
          "/Sources/lib/file2.rb" => %w(file3 file4)
        }, MotionBundler::Require.files_dependencies)
      end
    end

  end
end