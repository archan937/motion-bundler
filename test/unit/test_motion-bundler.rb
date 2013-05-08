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
        assert_equal [motion_bundler_file("motion-bundler/simulator/boot.rb")], MotionBundler.default_files

        MotionBundler.expects(:simulator?).returns(false)
        assert_equal [motion_bundler_file("motion-bundler/device/boot.rb")], MotionBundler.default_files
      end

      it "should be able to touch MotionBundler::MOTION_BUNDLER_FILE" do
        File.expects(:open).with(MotionBundler::MOTION_BUNDLER_FILE, "w")
        MotionBundler.send :touch_motion_bundler
      end

      it "should be able to write to MotionBundler::MOTION_BUNDLER_FILE" do
        MotionBundler::Require.expects(:requires).returns("foo.rb" => ["bar"])
        File.any_instance.expects(:<<).with <<-RUBY_CODE.gsub("          ", "")
          module MotionBundler
            REQUIRED = [
              "bar"
            ]
          end
        RUBY_CODE
        MotionBundler.send :write_motion_bundler

        MotionBundler::Require.expects(:requires).returns("foo.rb" => ["fubar/foo/bar", "fubar/foo/baz", "fubar/foo/qux"])
        File.any_instance.expects(:<<).with <<-RUBY_CODE.gsub("          ", "")
          module MotionBundler
            REQUIRED = [
              "fubar/foo/bar",
              "fubar/foo/baz",
              "fubar/foo/qux"
            ]
          end
        RUBY_CODE
        MotionBundler.send :write_motion_bundler

        File.expects(:open).with(MotionBundler::MOTION_BUNDLER_FILE, "w")
        MotionBundler.send :write_motion_bundler
      end

      describe "calling `setup`" do
        it "should require the :motion Bundler group and trace requires" do
          object = mock "object"
          object.expects :do_something

          Bundler.expects(:require).with(:motion)
          MotionBundler.setup do |app|
            object.do_something
          end

          MotionBundler.expects(:trace_require)
          MotionBundler.expects(:touch_motion_bundler)
          MotionBundler.expects(:write_motion_bundler)
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
            motion_bundler_file("motion-bundler.rb"),
            motion_bundler_file("motion-bundler/simulator/boot.rb"),
            motion_bundler_file("motion-bundler/simulator/core_ext.rb"),
            motion_bundler_file("motion-bundler/simulator/motion-bundler.rb"),
            "APP",
            "BUNDLER",
            "gems/foo-0.1.0/lib/foo.rb",
            "gems/foo-0.1.0/lib/foo/bar.rb",
            "gems/foo-0.1.0/lib/foo/version.rb",
            "ruby/foo.rb"
          ]
          MotionBundler::Require.expects(:files_dependencies).returns({
            motion_bundler_file("motion-bundler.rb") => [
              motion_bundler_file("motion-bundler/simulator/boot.rb")
            ],
            motion_bundler_file("motion-bundler/simulator/boot.rb") => [
              motion_bundler_file("motion-bundler/simulator/core_ext.rb"),
              motion_bundler_file("motion-bundler/simulator/motion-bundler.rb")
            ],
            "APP" => [
              "ruby/foo.rb"
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
            motion_bundler_file("motion-bundler/simulator/boot.rb"),
            motion_bundler_file("motion-bundler/simulator/core_ext.rb"),
            motion_bundler_file("motion-bundler/simulator/motion-bundler.rb"),
            "gems/foo-0.1.0/lib/foo.rb",
            "gems/foo-0.1.0/lib/foo/bar.rb",
            "gems/foo-0.1.0/lib/foo/version.rb",
            "ruby/foo.rb",
            "delegate.rb",
            "controller.rb"
          ])
          Motion::Project::App.any_instance.expects(:files_dependencies).with({
            motion_bundler_file("motion-bundler/simulator/boot.rb") => [
              motion_bundler_file("motion-bundler/simulator/core_ext.rb"),
              motion_bundler_file("motion-bundler/simulator/motion-bundler.rb"),
              "ruby/foo.rb"
            ],
            "gems/foo-0.1.0/lib/foo.rb" => [
              motion_bundler_file("motion-bundler/simulator/boot.rb"),
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