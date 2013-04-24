require File.expand_path("../../../test_helper", __FILE__)

module Motion
  module Device
    class TestCoreExt < MiniTest::Unit::TestCase

      describe "lib/motion-bundler/device/core_ext.rb" do
        it "should ignore require statements without a warning" do
          MotionBundler.expects(:simulator?).returns false
          taintable_core do
            assert_output "" do
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