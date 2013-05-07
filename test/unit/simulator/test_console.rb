require File.expand_path("../../../test_helper", __FILE__)
require "motion-bundler/simulator/console"

module Unit
  module Simulator
    class TestConsole < MiniTest::Unit::TestCase

      describe MotionBundler::Simulator::Console do
        it "should print warnings as expected" do
          String.class_eval do
            alias :yellow :to_s
          end
          assert_output "   Warning Called `require \"foo\"` from\n           <unknown path>\n" do
            MotionBundler::Simulator::Console.warn "require \"foo\"", nil
          end
          assert_output "   Warning Called `require \"foo\"` from\n           /Users/paulengel/fu/baz.rb:47\n" do
            MotionBundler::Simulator::Console.warn "require \"foo\"", "/Users/paulengel/fu/baz.rb:47:in `<module:SlotMachine>'"
          end
          assert_output "   Warning Called `Foo.bar` from\n           <unknown path>\n" do
            MotionBundler::Simulator::Console.warn "Foo", :bar, nil
          end
          assert_output "   Warning Called `Foo.bar` from\n           /Users/paulengel/fu/baz.rb:47\n" do
            MotionBundler::Simulator::Console.warn "Foo", :bar, "/Users/paulengel/fu/baz.rb:47:in `<module:SlotMachine>'"
          end
        end
      end

    end
  end
end