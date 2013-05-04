require File.expand_path("../../../test_helper", __FILE__)

module Unit
  module Require
    class TestTracer < MiniTest::Unit::TestCase

      describe MotionBundler::Require::Tracer do

        describe "calling `yield`" do
          it "should start, yield and stop" do
            object = mock "object"
            object.expects :do_something

            MotionBundler::Require::Tracer.expects :start
            MotionBundler::Require::Tracer.expects :stop
            MotionBundler::Require::Tracer.yield do
              object.do_something
            end
          end

          describe "when error raised" do
            it "should stop" do
              MotionBundler::Require::Tracer.expects :start
              MotionBundler::Require::Tracer.expects :stop
              begin
                MotionBundler::Require::Tracer.yield do
                  raise
                end
              rescue
              end
            end
          end
        end

        describe "calling `start`" do
          it "should create a log instance" do
            Thread.current[:motion_bundler_log] = nil
            MotionBundler::Require::Tracer.send :start
            assert_equal MotionBundler::Require::Tracer::Log, Thread.current[:motion_bundler_log].class
            assert_equal MotionBundler::Require::Tracer .log, Thread.current[:motion_bundler_log]
          end

          describe "having the log instance already defined" do
            it "should clear the log instance" do
              MotionBundler::Require::Tracer.send :start
              MotionBundler::Require::Tracer.log.expects(:clear)
              MotionBundler::Require::Tracer.send :start
            end
          end

          it "should hook into require relatied core methods" do
            MotionBundler::Require::Tracer::Hooks.expects :hook
            MotionBundler::Require::Tracer.send :start
          end
        end

        describe "calling `stop`" do
          it "should unhook form require relatied core methods" do
            MotionBundler::Require::Tracer::Hooks.expects :unhook
            MotionBundler::Require::Tracer.send :stop
          end
        end

        describe "tracing require statements" do
          it "should log dependencies as expected" do
            assert_equal({}, MotionBundler::Require::Tracer.log.instance_variable_get(:@log))

            MotionBundler::Require::Tracer.yield do
              require "a"
              require "b"
              require "c"
            end

            assert_equal({
              __FILE__ => [
                File.expand_path("../../../lib/a.rb", __FILE__),
                File.expand_path("../../../lib/b.rb", __FILE__),
                File.expand_path("../../../lib/c.rb", __FILE__)
              ],
              File  .expand_path("../../../lib/b.rb"  , __FILE__) => [
                File.expand_path("../../../lib/b/a.rb", __FILE__),
                File.expand_path("../../../lib/b/b.rb", __FILE__)
              ],
              File  .expand_path("../../../lib/b/a.rb"  , __FILE__) => [
                File.expand_path("../../../lib/b/a/a.rb", __FILE__)
              ]
            }, MotionBundler::Require::Tracer.log.instance_variable_get(:@log))
          end
        end

      end

    end
  end
end