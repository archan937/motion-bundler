require File.expand_path("../../../test_helper", __FILE__)

module Motion
  module Simulator
    class TestCoreExt < MiniTest::Unit::TestCase

      describe "lib/motion-bundler/simulator/core_ext.rb" do
        it "should ignore require statements with a warning" do
          MotionBundler.expects(:simulator?).returns true
          taintable_core do
            assert_output "Require \"a\" ignored\n" do
              MotionBundler::Require.default_files.each do |default_file|
                require default_file
              end
              require "a"
            end
          end
          assert_raises NameError do
            A
          end
          require "a"
          assert A
        end
      end

    end
  end
end