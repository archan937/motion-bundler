require File.expand_path("../../test_helper", __FILE__)

module Unit
  class TestTimeSlots < MiniTest::Unit::TestCase

    describe TimeSlots do
      it "should merge slots on initialization" do
        time_slots = TimeSlots.new 1015..1100, 1100..1115
        assert_equal [TimeSlot.new(1015..1115)], time_slots.range_slots
      end

      it "should be able to add slots" do
        time_slot = TimeSlot.new 1015..1100

        assert_equal TimeSlots.new(1015..1130), (time_slot + (1055..1130))
        assert_equal TimeSlots.new(1015..1130), (time_slot + TimeSlot.new(1055..1130))
        assert_equal TimeSlots.new(1015..1130, 1145..1200), (time_slot + TimeSlots.new(1055..1130, 1145..1200))
      end

      it "should be able to subtract slots" do
        time_slot = TimeSlot.new 1015..1100

        assert_equal TimeSlots.new(1015..1030, 1045..1100), (time_slot - (1030..1045))
        assert_equal TimeSlots.new(1015..1055), (time_slot - TimeSlot.new(1055..1130))
        assert_equal TimeSlots.new(1015..1045, 1055..1100), (time_slot - TimeSlots.new(1045..1055, 1145..1200))
      end

      it "should be able to match available slots" do
        time_slots = TimeSlots.new(1015..1100, 1230..1337)

        assert_equal [
          TimeSlot.new(1015..1035),
          TimeSlot.new(1030..1050),
          TimeSlot.new(1230..1250),
          TimeSlot.new(1245..1305),
          TimeSlot.new(1300..1320),
          TimeSlot.new(1315..1335)
        ], time_slots.match(20)

        assert_equal [
          TimeSlot.new(1015..1035),
          TimeSlot.new(1025..1045),
          TimeSlot.new(1035..1055),
          TimeSlot.new(1230..1250),
          TimeSlot.new(1240..1300),
          TimeSlot.new(1250..1310),
          TimeSlot.new(1300..1320),
          TimeSlot.new(1310..1330)
        ], time_slots.match(20, 10)
      end
    end

  end
end