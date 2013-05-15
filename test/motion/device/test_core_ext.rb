require File.expand_path("../../../test_helper", __FILE__)

module Motion
  module Device
    class TestCoreExt < MiniTest::Unit::TestCase

      describe "lib/motion-bundler/device/core_ext.rb" do
        before do
          ENV["MB_SILENCE_CORE"] = "true"
        end

        it "should ignore require statements without a warning" do
          MotionBundler.expects(:simulator?).returns false
          last_loaded_feature = nil

          assert_output "" do
            MotionBundler.default_files.each do |default_file|
              require default_file
            end
            last_loaded_feature = $LOADED_FEATURES.last

            assert_nil require("a")
            assert_nil require_relative("../../lib/a")
            assert_nil load("../../lib/a.rb")

            class Foo
              autoload :A, "../../lib/a.rb"
            end
          end

          assert_equal last_loaded_feature, $LOADED_FEATURES.last
          assert_raises NameError do
            A
          end
          assert_raises NameError do
            Foo::A
          end
        end
      end

    end
  end
end