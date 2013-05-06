require File.expand_path("../../../test_helper", __FILE__)
require "motion-bundler/simulator/motion-bundler"

module Unit
  module Simulator
    class TestMotionBundler < MiniTest::Unit::TestCase

      describe ::Simulator::MotionBundler do
        it "should print warnings as expected" do
          assert_output "   Warning Called `require \"foo\"` from\n           <unknown path>\n" do
            ::Simulator::MotionBundler.warn "require \"foo\"", nil
          end
          assert_output "   Warning Called `require \"foo\"` from\n           /Users/paulengel/fu/baz.rb:47\n" do
            ::Simulator::MotionBundler.warn "require \"foo\"", "/Users/paulengel/fu/baz.rb:47:in `<module:SlotMachine>'"
          end
          assert_output "   Warning Called `Foo.bar` from\n           <unknown path>\n" do
            ::Simulator::MotionBundler.warn "Foo", :bar, nil
          end
          assert_output "   Warning Called `Foo.bar` from\n           /Users/paulengel/fu/baz.rb:47\n" do
            ::Simulator::MotionBundler.warn "Foo", :bar, "/Users/paulengel/fu/baz.rb:47:in `<module:SlotMachine>'"
          end
        end
      end

    end
  end
end