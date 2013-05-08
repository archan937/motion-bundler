require File.expand_path("../../../test_helper", __FILE__)

motion_gemfile <<-G
gem "motion-bundler", :path => "#{motion_bundler_file ".."}"
group :motion do
  gem "slot_machine", :path => "#{gem_path "slot_machine"}"
end
G

module Motion
  module Simulator
    class TestSetup < MiniTest::Unit::TestCase

      describe "MotionBundler.setup" do
        it "should register files and files_dependencies to the RubyMotion app" do
          assert_raises NameError do
            SlotMachine
          end

          colorize = "#{Bundler.load.specs.detect{|x| x.name == "colorize"}.full_gem_path}/lib/colorize.rb"

          files = %w(/Users/paulengel/foo.rb /Users/paulengel/bar.rb)
          Motion::Project::App.any_instance.expects(:files).returns files
          Motion::Project::App.any_instance.expects(:files=).with([
            colorize,
            motion_bundler_file("motion-bundler/simulator/boot.rb"),
            motion_bundler_file("motion-bundler/simulator/console.rb"),
            motion_bundler_file("motion-bundler/simulator/core_ext.rb"),
            gem_path("slot_machine/lib/slot.rb"),
            gem_path("slot_machine/lib/slot_machine.rb"),
            gem_path("slot_machine/lib/slot_machine/slot.rb"),
            gem_path("slot_machine/lib/slot_machine/slots.rb"),
            gem_path("slot_machine/lib/slot_machine/version.rb"),
            gem_path("slot_machine/lib/slots.rb"),
            gem_path("slot_machine/lib/time_slot.rb"),
            gem_path("slot_machine/lib/time_slots.rb"),
            lib_file("a.rb"),
            lib_file("b/a/a.rb"),
            MotionBundler::MOTION_BUNDLER_FILE,
            "/Users/paulengel/foo.rb",
            "/Users/paulengel/bar.rb"
          ])
          Motion::Project::App.any_instance.expects(:files_dependencies).with(
            motion_bundler_file("motion-bundler/simulator/boot.rb") => [
              motion_bundler_file("motion-bundler/simulator/core_ext.rb"),
              colorize,
              motion_bundler_file("motion-bundler/simulator/console.rb"),
              lib_file("a.rb"),
              lib_file("b/a/a.rb")
            ],
            gem_path("slot_machine/lib/slot_machine.rb") => [
              motion_bundler_file("motion-bundler/simulator/boot.rb"),
              gem_path("slot_machine/lib/slot_machine/version.rb"),
              gem_path("slot_machine/lib/slot_machine/slot.rb"),
              gem_path("slot_machine/lib/slot_machine/slots.rb"),
              gem_path("slot_machine/lib/slot.rb"),
              gem_path("slot_machine/lib/slots.rb"),
              gem_path("slot_machine/lib/time_slot.rb"),
              gem_path("slot_machine/lib/time_slots.rb")
            ]
          )

          MotionBundler.setup do |app|
            app.require "a"
            app.require "b/a/a"
          end

          assert SlotMachine
        end
      end

    end
  end
end