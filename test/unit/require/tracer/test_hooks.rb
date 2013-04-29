require File.expand_path("../../../../test_helper", __FILE__)

module Unit
  module Require
    module Tracer
      class TestHooks < MiniTest::Unit::TestCase

        describe MotionBundler::Require::Tracer::Hooks do
          it "should hook into core methods" do
            assert_equal false, Kernel.respond_to?(:require_with_hook)
            assert_equal false, Object.respond_to?(:require_with_hook)

            MotionBundler::Require::Tracer::Hooks.send :hook
            assert_equal true, Kernel.respond_to?(:require_with_hook)
            assert_equal true, Object.respond_to?(:require_with_hook)

            MotionBundler::Require::Tracer::Hooks.send :unhook
            assert_equal false, Kernel.respond_to?(:require_with_hook)
            assert_equal false, Object.respond_to?(:require_with_hook)
          end
        end

      end
    end
  end
end