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
        assert_equal motion_bundler_file("motion-bundler/simulator/boot.rb"), MotionBundler.boot_file

        MotionBundler.expects(:simulator?).returns(false)
        assert_equal motion_bundler_file("motion-bundler/device/boot.rb"), MotionBundler.boot_file
      end

      it "should be able to touch MotionBundler::MOTION_BUNDLER_FILE" do
        File.expects(:open).with(MotionBundler::MOTION_BUNDLER_FILE, "w")
        MotionBundler.send :touch_motion_bundler
      end

      it "should be able to write to MotionBundler::MOTION_BUNDLER_FILE" do
        File.any_instance.expects(:<<).with <<-RUBY_CODE.gsub("          ", "")
          module MotionBundler
            FILES = [
              "foo",
              "bar",
              "qux"
            ]
            FILES_DEPENDENCIES = {
              "foo.rb" => [
                "bar"
              ],
              "MOTION_BUNDLER" => [
                "qux"
              ]
            }
            REQUIRED = [
              "fu",
              "baz"
            ]
          end
        RUBY_CODE
        MotionBundler.send :write_motion_bundler, %w(foo bar qux), {"foo.rb" => ["bar"], motion_bundler_file("motion-bundler.rb") => ["qux"]}, %w(fu baz)

        File.expects(:open).with(MotionBundler::MOTION_BUNDLER_FILE, "w")
        MotionBundler.send :write_motion_bundler, [], {}, []
      end

      it "should be able to register files to require" do
        assert_equal [], MotionBundler.send(:app_requires)
        MotionBundler.app_require "foo/bar.rb"
        assert_equal ["foo/bar.rb"], MotionBundler.send(:app_requires)
      end

      describe "calling `setup`" do
        it "should require the :motion Bundler group and trace requires" do
          object = mock "object"
          object.expects :do_something

          Bundler.expects(:require).with(:motion)
          MotionBundler.setup do |app|
            app.require "foo"
            object.do_something
          end

          MotionBundler.expects(:touch_motion_bundler)
          MotionBundler.expects(:ripper_require)
          MotionBundler.expects(:tracer_require)
          MotionBundler.expects(:write_motion_bundler)
          MotionBundler.setup
        end

        it "should trace requires and register files and files dependencies" do
          Bundler.expects(:require).with(:motion)
          Motion::Project::App.any_instance.expects(:files).returns(%w(delegate.rb controller.rb))

          MotionBundler::Require.expects(:files).returns([
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
          ])

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

          Motion::Project::App.any_instance.expects(:files=).with(expand_paths [
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

          Motion::Project::App.any_instance.expects(:files_dependencies).with(expand_paths({
            motion_bundler_file("motion-bundler/simulator/boot.rb") => [
              motion_bundler_file("motion-bundler/simulator/core_ext.rb"),
              motion_bundler_file("motion-bundler/simulator/motion-bundler.rb")
            ],
            "gems/foo-0.1.0/lib/foo.rb" => [
              motion_bundler_file("motion-bundler/simulator/boot.rb"),
              "gems/foo-0.1.0/lib/foo/bar.rb",
              "gems/foo-0.1.0/lib/foo/version.rb"
            ]
          }))

          MotionBundler.setup
        end
      end
    end

  end
end