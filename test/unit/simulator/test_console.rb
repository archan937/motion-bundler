require File.expand_path("../../../test_helper", __FILE__)
require "motion-bundler/simulator/console"

module Unit
  module Simulator
    class TestConsole < MiniTest::Unit::TestCase

      describe MotionBundler::Simulator::Console do
        before do
          MotionBundler.send :remove_const, :REQUIRED if defined?(MotionBundler::REQUIRED)
          MotionBundler::REQUIRED = ["baz"]
        end

        after do
          MotionBundler.send :remove_const, :REQUIRED
        end

        it "should print warnings as expected" do
          String.class_eval do
            alias :yellow :to_s
            alias :green :to_s
          end
          assert_output "   Warning Called `require \"foo\"`\n           Add within setup block: app.require \"foo\"\n" do
            MotionBundler::Simulator::Console.warn do
              require "foo"
            end
          end
          assert_output "" do
            MotionBundler::Simulator::Console.warn do
              require "baz"
            end
          end
          assert_output "   Warning Called `require_relative \"foo\"`\n           Add within setup block: app.require \"foo\"\n" do
            MotionBundler::Simulator::Console.warn do
              require_relative "foo"
            end
          end
          assert_output "   Warning Called `load \"foo\"`\n           Add within setup block: app.require \"foo\"\n" do
            MotionBundler::Simulator::Console.warn do
              load "foo"
            end
          end
          assert_output "   Warning Called `autoload :Foo, \"foo\"`\n           Add within setup block: app.require \"foo\"\n" do
            MotionBundler::Simulator::Console.warn do
              autoload :Foo, "foo"
            end
          end
          assert_output "   Warning Called `Foo.bar`\n           Don't do that!\n" do
            MotionBundler::Simulator::Console.warn do
              object "Foo"
              method :bar
              message "Don't do that!"
            end
          end
        end
      end

    end
  end
end