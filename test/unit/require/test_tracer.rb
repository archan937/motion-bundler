require File.expand_path("../../../test_helper", __FILE__)

module Unit
  module Require
    class TestTracer < MiniTest::Unit::TestCase

      describe MotionBundler::Require::Tracer do

        describe "when calling `start`" do
          before do
            Thread.current[:motion_bundler_log] = nil
            MotionBundler::Require::Tracer.start
          end

          it "should create a log instance" do
            assert_equal Thread.current[:motion_bundler_log].class, MotionBundler::Require::Tracer::Log
            assert_equal Thread.current[:motion_bundler_log], MotionBundler::Require::Tracer.log
          end
        end

      end

    end
  end
end