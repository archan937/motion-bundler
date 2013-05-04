require File.expand_path("../../../test_helper", __FILE__)

module Unit
  module Require
    class TestMocker < MiniTest::Unit::TestCase

      describe MotionBundler::Require::Mocker do

        describe "hooks" do
          it "should have MotionBundler::Require::Mocker::Hooks included" do
            assert_equal true, MotionBundler::Require::Mocker.included_modules.include?(MotionBundler::Require::Mocker::Hooks)
          end
        end

        describe "calling `yield`" do
          it "should start, yield and stop" do
            object = mock "object"
            object.expects :do_something

            MotionBundler::Require::Mocker.expects :start
            MotionBundler::Require::Mocker.expects :stop
            MotionBundler::Require::Mocker.yield do
              object.do_something
            end
          end

          it "should stop when error raised" do
            MotionBundler::Require::Mocker.expects :start
            MotionBundler::Require::Mocker.expects :stop
            begin
              MotionBundler::Require::Mocker.yield do
                raise
              end
            rescue
            end
          end
        end

        describe "calling `start`" do
          it "should hook into mock related core methods" do
            MotionBundler::Require::Mocker.expects :hook
            MotionBundler::Require::Mocker.send :start
          end
        end

        describe "calling `stop`" do
          it "should unhook from mock related core methods" do
            MotionBundler::Require::Mocker.expects :unhook
            MotionBundler::Require::Mocker.send :stop
          end
        end

      end

    end
  end
end