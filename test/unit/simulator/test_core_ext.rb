require File.expand_path("../../../test_helper", __FILE__)
require "motion-bundler/simulator/console"

module Unit
  module Simulator
    class TestCoreExt < MiniTest::Unit::TestCase

      describe "lib/motion-bundler/simulator/core_ext.rb" do
        before do
          ENV["MB_SILENCE_CORE"] = "true"
        end

        it "should override core methods as expected" do
          assert_equal false, Kernel.respond_to?(:console)
          assert_equal false, Kernel.respond_to?(:_ruby_require)

          taintable_core do
            MotionBundler::Simulator::Console.expects(:warn).at_least_once

            load lib_file("motion-bundler/simulator/core_ext.rb")
            assert_equal true, Kernel.respond_to?(:console)
            assert_equal true, Kernel.respond_to?(:_ruby_require)

            require "foo"
            require_relative "foo/bar"
            load "foo/baz"
            autoload :Qux, "foo/qux"

            Unit.require "foo"
            Unit.require_relative "foo/bar"
            Unit.load "foo/baz"
            Unit.autoload :Qux, "foo/qux"

            TestCoreExt.class_eval "def foo; end"
            TestCoreExt.module_eval "def foo; end"
            TestCoreExt.module_eval do
              def foo; end
            end
            Object.new.instance_eval "def foo; end"
          end

          assert_equal false, Kernel.respond_to?(:console)
          assert_equal false, Kernel.respond_to?(:_ruby_require)
        end
      end

    end
  end
end