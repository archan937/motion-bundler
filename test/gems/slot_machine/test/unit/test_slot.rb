require File.expand_path("../../test_helper", __FILE__)

module Unit
  class TestSlot < MiniTest::Unit::TestCase

    describe Slot do
      describe "class methods" do
        it "should have the expected class methods" do
          assert Slot.respond_to?(:interval)
          assert Slot.respond_to?(:default_interval)

          assert_equal 10, Slot.default_interval
          Slot.class_eval do
            interval 20
          end
          assert_equal 20, Slot.default_interval

          Slot.class_eval do
            interval 10
          end
          assert_equal 10, Slot.default_interval
        end
      end

      describe "instance methods" do
        it "should have the expected instance methods" do
          slot = Slot.new 1
          assert slot.respond_to?(:range?)
          assert slot.respond_to?(:length?)
          assert slot.respond_to?(:start)
          assert slot.respond_to?(:start=)
          assert slot.respond_to?(:end)
          assert slot.respond_to?(:end=)
          assert slot.respond_to?(:length)
          assert slot.respond_to?(:length=)
          assert slot.respond_to?(:to_compared)
          assert slot.respond_to?(:match)
          assert slot.respond_to?(:+)
          assert slot.respond_to?(:-)
        end
      end

      describe "initialization" do
        it "should accept a range" do
          slot = Slot.new 10..20
          assert_equal 10, slot.start
          assert_equal 20, slot.end
        end

        it "should accept a length" do
          slot = Slot.new 10
          assert_equal 10, slot.length
        end

        it "should raise an exception when invalid" do
          assert_raises ArgumentError do
            Slot.new
          end
          assert_raises ArgumentError do
            Slot.new "bar"
          end
          assert_raises ArgumentError do
            Slot.new 1.."bar"
          end
          assert_raises ArgumentError do
            Slot.new "bar"..1
          end
          assert_raises ArgumentError do
            Slot.new "slot".."bar"
          end
        end

        it "should return whether it's a range or a length" do
          slot = Slot.new 10..20
          assert slot.range?
          assert !slot.length?

          slot = Slot.new 10
          assert !slot.range?
          assert slot.length?
        end
      end

      describe "equality" do
        it "should return whether it equals another object" do
          slot = Slot.new 1

          assert !(slot == 1)
          assert !(slot == Slot.new(1..2))
          assert_equal slot, Slot.new(1)

          slot = Slot.new 1..2

          assert !(slot == (1..2))
          assert !(slot == Slot.new(1))
          assert_equal slot, Slot.new(1..2)
        end
      end

      describe "range slots" do
        it "should only set start or end (not length) and typecast the passed argument" do
          slot = Slot.new 10..20

          slot.start = 0
          assert_equal 0, slot.start

          assert_raises ArgumentError do
            slot.start = "bar"
          end

          slot.end = 10
          assert_equal 10, slot.end

          assert_raises ArgumentError do
            slot.end = "bar"
          end

          slot.length = 30
          assert_nil slot.length

          slot.length = "bar"
          assert_nil slot.length
        end

        it "should validate the assigned value" do
          assert_raises ArgumentError do
            Slot.new -10..10
          end

          assert_raises ArgumentError do
            Slot.new 10..1
          end

          slot = Slot.new 10..20

          assert_raises ArgumentError do
            slot.start = -10
          end

          assert_equal 10, slot.start

          assert_raises ArgumentError do
            slot.start = 30
          end

          assert_equal 10, slot.start

          assert_raises ArgumentError do
            slot.end = 5
          end

          assert_equal 20, slot.end

          assert_raises ArgumentError do
            slot.end = -10
          end
        end

        it "should represent itself as an array when invoking to_compared" do
          assert_equal [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], Slot.new(10..20).send(:to_compared)
          assert_equal 50, Slot.new(855..905).send(:to_compared).size
        end

        it "should be able to match available slots" do
          slot = Slot.new 0..15
          assert_equal [], slot.match(20)
          assert_equal [Slot.new(0..15)], slot.match(15)
          assert_equal [Slot.new(0..10)], slot.match(10)
          assert_equal [Slot.new(0..10), Slot.new(5..15)], slot.match(10, 5)
          assert_equal [Slot.new(0..10), Slot.new(5..15)], slot.match(Slot.new(10), 5)
          assert_equal [Slot.new(0..10), Slot.new(5..15)], Slot.new(10).match(0..15, 5)
          assert_equal [Slot.new(0..10), Slot.new(5..15)], Slot.new(10).match(Slot.new(0..15), 5)
          assert_equal [
            Slot.new(0..5),
            Slot.new(5..10),
            Slot.new(10..15)
          ], slot.match(5, 5)

          slot = Slot.new 10..20
          assert_equal [], slot.match(0..5)
          assert_equal [], slot.match(25..30)
          assert_equal [Slot.new(10..20)], slot.match(10..20)
          assert_equal [Slot.new(10..20)], slot.match(0..30)
          assert_equal [Slot.new(10..15)], slot.match(0..15)
          assert_equal [Slot.new(15..20)], slot.match(15..30)

          assert_raises ArgumentError do
            slot.match 0
          end
          assert_raises ArgumentError do
            slot.match -1
          end
          assert_raises ArgumentError do
            slot.match 1, 0
          end
          assert_raises ArgumentError do
            Slot.new(5).match(5)
          end
        end

        it "should be able to add other slots" do
          assert_equal Slots, (Slot.new(1..10) + (5..8)).class
          assert_equal Slots, (Slot.new(1..10) + Slot.new(5..8)).class
          assert_equal Slots, (Slot.new(1..10) + [5..8]).class
          assert_equal Slots, (Slot.new(1..10) + Slots.new([5..8])).class
        end

        it "should be able to subtract other slots" do
          assert_equal Slots, (Slot.new(1..10) - (5..8)).class
          assert_equal Slots, (Slot.new(1..10) - Slot.new(5..8)).class
          assert_equal Slots, (Slot.new(1..10) - [5..8]).class
          assert_equal Slots, (Slot.new(1..10) - Slots.new([5..8])).class
        end
      end

      describe "length slots" do
        it "should only set length (not start or end) and typecast the passed argument" do
          slot = Slot.new 10

          slot.start = 0
          assert_nil slot.start

          slot.start = "bar"
          assert_nil slot.start

          slot.end = 10
          assert_nil slot.end

          slot.end = "bar"
          assert_nil slot.end

          slot.length = 30
          assert_equal 30, slot.length

          assert_raises ArgumentError do
            slot.length = "bar"
          end
        end

        it "should validate the assigned value" do
          assert_raises ArgumentError do
            Slot.new -10
          end

          slot = Slot.new 10

          assert_raises ArgumentError do
            slot.length = -10
          end
        end

        it "should represent itself as an integer when invoking to_compared" do
          assert_equal 10, Slot.new(10).send(:to_compared)
        end
      end
    end

  end
end