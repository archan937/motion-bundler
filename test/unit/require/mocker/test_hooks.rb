require File.expand_path("../../../../test_helper", __FILE__)

module Unit
  module Require
    module Mocker
      class TestHooks < MiniTest::Unit::TestCase

        describe MotionBundler::Require::Mocker::Hooks do
          it "should hook into core methods" do
            assert_equal false, Kernel.respond_to?(:require_with_mb_mock)
            assert_equal false, Object.respond_to?(:require_with_mb_mock)

            MotionBundler::Require::Mocker.hook
            assert_equal true, Kernel.respond_to?(:require_with_mb_mock)
            assert_equal true, Object.respond_to?(:require_with_mb_mock)

            MotionBundler::Require.expects(:resolve).with("a").returns "a"
            require "a"

            MotionBundler::Require::Mocker.unhook
            assert_equal false, Kernel.respond_to?(:require_with_mb_mock)
            assert_equal false, Object.respond_to?(:require_with_mb_mock)
          end
        end

      end
    end
  end
end