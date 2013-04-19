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
            assert_equal MotionBundler::Require::Tracer::Log, Thread.current[:motion_bundler_log].class
            assert_equal MotionBundler::Require::Tracer .log, Thread.current[:motion_bundler_log]
          end

          describe "having the log instance already defined" do
            it "should clear the log instance" do
              MotionBundler::Require::Tracer.log.expects(:clear)
              MotionBundler::Require::Tracer.start
            end
          end
        end

      end

    end
  end
end