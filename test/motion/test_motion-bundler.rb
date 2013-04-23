require File.expand_path("../../test_helper", __FILE__)

motion_gemfile <<-G
group :motion do
  gem "slot_machine", :path => "#{gem_path "slot_machine"}"
end
G

module Motion
  class TestMotionBundler < MiniTest::Unit::TestCase

    describe MotionBundler do
      it "should register files and files_dependencies to the RubyMotion app" do
        assert_raises NameError do
          SlotMachine
        end

        files = %w(/Users/paulengel/foo.rb /Users/paulengel/bar.rb)
        Motion::Project::App.any_instance.expects(:files).returns files
        Motion::Project::App.any_instance.expects(:files=).with([
          gem_path("slot_machine/lib/slot.rb"),
          gem_path("slot_machine/lib/slot_machine.rb"),
          gem_path("slot_machine/lib/slot_machine/slot.rb"),
          gem_path("slot_machine/lib/slot_machine/slots.rb"),
          gem_path("slot_machine/lib/slot_machine/version.rb"),
          gem_path("slot_machine/lib/slots.rb"),
          gem_path("slot_machine/lib/time_slot.rb"),
          gem_path("slot_machine/lib/time_slots.rb"),
          "/Users/paulengel/foo.rb",
          "/Users/paulengel/bar.rb"
        ])
        Motion::Project::App.any_instance.expects(:files_dependencies).with(
          gem_path("slot_machine/lib/slot_machine.rb") => [
            gem_path("slot_machine/lib/slot_machine/version.rb"),
            gem_path("slot_machine/lib/slot_machine/slot.rb"),
            gem_path("slot_machine/lib/slot_machine/slots.rb"),
            gem_path("slot_machine/lib/slot.rb"),
            gem_path("slot_machine/lib/slots.rb"),
            gem_path("slot_machine/lib/time_slot.rb"),
            gem_path("slot_machine/lib/time_slots.rb")
          ]
        )

        MotionBundler.setup
        assert SlotMachine
      end
    end

  end
end