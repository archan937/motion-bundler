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

      it "should determine Motion::Project::App default files" do
        MotionBundler.expects(:simulator?).returns(true)
        assert_equal [lib_file("motion-bundler/simulator/boot.rb")], MotionBundler.default_files

        MotionBundler.expects(:simulator?).returns(false)
        assert_equal [lib_file("motion-bundler/device/boot.rb")], MotionBundler.default_files
      end

      describe "calling `setup`" do
        it "should require the :motion Bundler group and trace requires" do
          object = mock "object"
          object.expects :do_something

          Bundler.expects(:require).with(:motion)
          MotionBundler.setup do
            object.do_something
          end

          MotionBundler.expects(:trace_require)
          MotionBundler.setup
        end

        it "should trace requires and register files and files dependencies" do
          object = mock "object"
          object.expects :do_something

          MotionBundler.trace_require do
            object.do_something
          end

          MotionBundler::Require.expects :trace
          MotionBundler::Require.expects(:files).returns [
            lib_file("motion-bundler.rb"),
            lib_file("motion-bundler/simulator/boot.rb"),
            lib_file("motion-bundler/simulator/core_ext.rb"),
            lib_file("motion-bundler/simulator/motion-bundler.rb"),
            "BUNDLER",
            "gems/foo-0.1.0/lib/foo.rb",
            "gems/foo-0.1.0/lib/foo/bar.rb",
            "gems/foo-0.1.0/lib/foo/version.rb"
          ]
          MotionBundler::Require.expects(:files_dependencies).returns({
            lib_file("motion-bundler.rb") => [
              lib_file("motion-bundler/simulator/boot.rb")
            ],
            lib_file("motion-bundler/simulator/boot.rb") => [
              lib_file("motion-bundler/simulator/core_ext.rb"),
              lib_file("motion-bundler/simulator/motion-bundler.rb")
            ],
            "BUNDLER" => [
              "gems/foo-0.1.0/lib/foo.rb"
            ],
            "gems/foo-0.1.0/lib/foo.rb" => [
              "gems/foo-0.1.0/lib/foo/bar.rb",
              "gems/foo-0.1.0/lib/foo/version.rb"
            ]
          })
          Motion::Project::App.any_instance.expects(:files).returns(%w(delegate.rb controller.rb))

          Motion::Project::App.any_instance.expects(:files=).with([
            lib_file("motion-bundler/simulator/boot.rb"),
            lib_file("motion-bundler/simulator/core_ext.rb"),
            lib_file("motion-bundler/simulator/motion-bundler.rb"),
            "gems/foo-0.1.0/lib/foo.rb",
            "gems/foo-0.1.0/lib/foo/bar.rb",
            "gems/foo-0.1.0/lib/foo/version.rb",
            "delegate.rb",
            "controller.rb"
          ])
          Motion::Project::App.any_instance.expects(:files_dependencies).with({
            lib_file("motion-bundler/simulator/boot.rb") => [
              lib_file("motion-bundler/simulator/core_ext.rb"),
              lib_file("motion-bundler/simulator/motion-bundler.rb")
            ],
            "gems/foo-0.1.0/lib/foo.rb" => [
              lib_file("motion-bundler/simulator/boot.rb"),
              "gems/foo-0.1.0/lib/foo/bar.rb",
              "gems/foo-0.1.0/lib/foo/version.rb"
            ]
          })
          MotionBundler.setup
        end
      end
    end

  end
end