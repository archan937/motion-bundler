require File.expand_path("../../test_helper", __FILE__)

motion_gemfile <<-G
group :motion do
  gem "slot_machine"
end
G

module Motion
  class TestMotionBundler < MiniTest::Unit::TestCase

    describe MotionBundler do
      it "should register files and files_dependencies to the RubyMotion app" do
        assert_raises NameError do
          SlotMachine
        end
        Bundler.require :motion
        assert SlotMachine
      end
    end

  end
end