require File.expand_path("../../../../test_helper", __FILE__)

module Unit
  module Require
    module Tracer
      class TestHooks < MiniTest::Unit::TestCase

        describe MotionBundler::Require::Tracer::Hooks do
          it "should hook into core methods" do
            assert_equal false, Kernel.respond_to?(:require_with_hook)
            assert_equal false, Object.respond_to?(:require_with_hook)
            assert_equal false, Kernel.respond_to?(:require_relative_with_hook)
            assert_equal false, Object.respond_to?(:require_relative_with_hook)
            assert_equal false, Kernel.respond_to?(:load_with_hook)
            assert_equal false, Object.respond_to?(:load_with_hook)

            MotionBundler::Require::Tracer::Hooks.send :hook
            assert_equal true, Kernel.respond_to?(:require_with_hook)
            assert_equal true, Object.respond_to?(:require_with_hook)
            assert_equal true, Kernel.respond_to?(:require_relative_with_hook)
            assert_equal true, Object.respond_to?(:require_relative_with_hook)
            assert_equal true, Kernel.respond_to?(:load_with_hook)
            assert_equal true, Object.respond_to?(:load_with_hook)

            MotionBundler::Require::Tracer.log.expects(:register).with("#{__FILE__}:#{__LINE__ + 1}:in `block (2 levels) in <class:TestHooks>'")
            require "a"

            MotionBundler::Require::Tracer.log.expects(:register).with("#{__FILE__}:#{__LINE__ + 1}:in `block (2 levels) in <class:TestHooks>'")
            require_relative "../../../../lib/b"

            MotionBundler::Require::Tracer.log.expects(:register).with("#{__FILE__}:#{__LINE__ + 1}:in `block (2 levels) in <class:TestHooks>'")
            load "c.rb"

            MotionBundler::Require::Tracer.log.expects(:register).with("#{__FILE__}:#{__LINE__ + 2}:in `<module:SlotMachine>'")
            module ::SlotMachine
              autoload :VERSION, gem_path("slot_machine/lib/slot_machine/version")
            end

            MotionBundler::Require::Tracer::Hooks.send :unhook
            assert_equal false, Kernel.respond_to?(:require_with_hook)
            assert_equal false, Object.respond_to?(:require_with_hook)
            assert_equal false, Kernel.respond_to?(:require_relative_with_hook)
            assert_equal false, Object.respond_to?(:require_relative_with_hook)
            assert_equal false, Kernel.respond_to?(:load_with_hook)
            assert_equal false, Object.respond_to?(:load_with_hook)
          end
        end

      end
    end
  end
end