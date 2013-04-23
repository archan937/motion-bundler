require File.expand_path("../../test_helper", __FILE__)

module Unit
  class TestSlots < MiniTest::Unit::TestCase

    describe Slots do
      describe "instance methods" do
        it "should have the expected instance methods" do
          slots = Slots.new 1..10
          assert slots.respond_to?(:range_slots)
        end
      end

      describe "initialization" do
        it "should accept a range" do
          slots = Slots.new 10..20
          assert_equal [Slot.new(10..20)], slots.range_slots
        end

        it "should accept ranges" do
          slots = Slots.new 10..20, Slot.new(30..40)
          assert_equal [Slot.new(10..20), Slot.new(30..40)], slots.range_slots

          slots = Slots.new 10..20, Slot.new(22..30)
          assert_equal [Slot.new(10..20), Slot.new(22..30)], slots.range_slots
        end

        it "should merge slots on initialization" do
          slots = Slots.new 10..20, 20..30
          assert_equal [Slot.new(10..30)], slots.range_slots
        end

        it "should raise an exception when invalid" do
          assert_raises ArgumentError do
            Slots.new "bar"
          end
          assert_raises ArgumentError do
            Slots.new 1.."bar"
          end
          assert_raises ArgumentError do
            Slots.new "bar"..1
          end
          assert_raises ArgumentError do
            Slots.new "slot".."bar"
          end
        end
      end

      describe "equality" do
        it "should return whether it equals another object" do
          slots = Slots.new 1..2, 3..4

          assert !(slots == Slot.new(1..2))
          assert !(slots == Slots.new(1..2, 3..5))

          assert_equal slots, Slots.new(3..4, 1..2)
          assert_equal slots, Slots.new(1..2, 3..4)
          assert_equal slots, Slots.new([1..2, 3..4])
          assert_equal slots, Slots.new(Slot.new(1..2), Slot.new(3..4))
          assert_equal slots, [Slot.new(1..4)]
        end
      end

      describe "calculations" do
        it "should be able to add slots" do
          slots = Slots.new 0..10

          assert_equal Slots, (slots + (10..20)).class
          assert_equal Slots, (slots + Slot.new(10..20)).class
          assert_equal Slots, (slots + Slots.new(10..20)).class

          assert_equal Slots.new(0..20), (slots + (10..20))
          assert_equal Slots.new(0..10, 20..30), (slots + Slot.new(20..30))
          assert_equal Slots.new(0..10, 20..30, 40..60), (slots + Slots.new(20..30, 40..50) + (45..60))

          assert_equal Slots.new(0..15, 20..30), (((slots + (5..15)) + (20..25)) + (24..30))
        end

        it "should be able to subtract slots" do
          slots = Slots.new 0..30

          assert_equal Slots, (slots - (10..20)).class
          assert_equal Slots, (slots - Slot.new(10..20)).class
          assert_equal Slots, (slots - Slots.new(10..20)).class

          assert_equal Slots.new(0..10, 20..30), (slots - (10..20))
          assert_equal Slots.new(0..10, 20..30), (slots - Slot.new(10..20))
          assert_equal Slots.new(0..10, 20..30), (slots - Slots.new(10..20, 30..40))

          assert_equal Slots.new(0..5, 10..20, 25..30), (((slots - (20..25)) - (5..10)) - (20..22))
        end

        it "should be able to match available slots" do
          slots = Slots.new(0..10, 15..40, 50..65)

          assert_equal [
            Slot.new(0..10),
            Slot.new(15..25),
            Slot.new(25..35),
            Slot.new(50..60)
          ], slots.match(10)

          assert_equal [
            Slot.new(0..10),
            Slot.new(15..25),
            Slot.new(20..30),
            Slot.new(25..35),
            Slot.new(30..40),
            Slot.new(50..60),
            Slot.new(55..65)
          ], slots.match(10, 5)
        end
      end
    end

  end
end