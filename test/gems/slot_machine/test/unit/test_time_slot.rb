require File.expand_path("../../test_helper", __FILE__)

require "time"

module Unit
  class TestTimeSlot < MiniTest::Unit::TestCase

    describe TimeSlot do
      it "should have the expected default interval" do
        assert_equal 15, TimeSlot.default_interval
      end

      it "should validate the assigned value" do
        assert TimeSlot.new(855..859)
        assert_raises ArgumentError do
          TimeSlot.new 855..860
        end
      end

      it "should accept time objects" do
        assert_equal [
          198208010859,
          198208010900,
          198208010901,
          198208010902,
          198208010903,
          198208010904
        ], TimeSlot.new(Time.parse("1982-08-01 08:59")..Time.parse("1982-08-01 09:05")).send(:to_compared)
      end

      it "should represent itself as an array when invoking to_compared" do
        assert_equal 10 , TimeSlot.new(855..905).send(:to_compared).size
        assert_equal 222, TimeSlot.new(955..1337).send(:to_compared).size
        assert_equal [855, 856, 857, 858, 859, 900, 901, 902, 903, 904], TimeSlot.new(855..905).send(:to_compared)
      end

      it "should be able to match available slots" do
        time_slot = TimeSlot.new 1015..1200

        assert_equal [], time_slot.match(120)
        assert_equal [TimeSlot.new(1015..1155)], time_slot.match(100)
        assert_equal [TimeSlot.new(1015..1200)], time_slot.match(105)
        assert_equal [TimeSlot.new(1015..1145), TimeSlot.new(1030..1200)], time_slot.match(90)

        assert_equal [
          TimeSlot.new(1015..1140),
          TimeSlot.new(1025..1150),
          TimeSlot.new(1035..1200)
        ], time_slot.match(85, 10)

        assert_equal [
          TimeSlot.new(1015..1055),
          TimeSlot.new(1033..1113),
          TimeSlot.new(1051..1131),
          TimeSlot.new(1109..1149)
        ], time_slot.match(40, 18)

        assert_equal [
          TimeSlot.new(198208011015..198208011055),
          TimeSlot.new(198208011033..198208011113),
          TimeSlot.new(198208011051..198208011131),
          TimeSlot.new(198208011109..198208011149)
        ], TimeSlot.new(Time.parse("1982-08-01 10:15")..Time.parse("1982-08-01 12:00")).match(40, 18)

        assert_equal [], time_slot.match(945..1005)
        assert_equal [], time_slot.match(1205..1225)
        assert_equal [TimeSlot.new(1015..1200)], time_slot.match(1015..1200)
        assert_equal [TimeSlot.new(1015..1200)], time_slot.match(900..1300)
        assert_equal [TimeSlot.new(1015..1030)], time_slot.match(900..1030)
        assert_equal [TimeSlot.new(1155..1200)], time_slot.match(1155..1300)
      end
    end

  end
end