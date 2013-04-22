require File.expand_path("../../test_helper", __FILE__)
require "bundler"

module Unit
  class TestMotionBundler < MiniTest::Unit::TestCase

    describe MotionBundler do
      it "should require, trace and register files and files dependencies during setup" do
        object = mock "object"
        object.expects :do_something

        Bundler.expects(:require).with(:motion)
        MotionBundler.setup do
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