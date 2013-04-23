module SlotMachine
  module Slots

    def self.included(base)
      base.class_eval do
        def self.slot_class
          @slot_class ||= name.gsub(/s$/, "").split("::").inject(Object) do |mod, name|
            mod.const_get name
          end
        end
      end
    end

    def initialize(*ranges_or_range_slots)
      @range_slots = to_range_slots(add(ranges_or_range_slots.flatten))
    end

    def range_slots
      @range_slots || []
    end

    def match(other, interval = nil)
      range_slots.collect{|range_slot| range_slot.match other, interval}.flatten.uniq
    end

    def +(other)
      unless other.is_a?(Range) || other.is_a?(Array) || other.class == self.class.slot_class || other.class == self.class
        raise ArgumentError, "Either subtract a Range, an Array, #{self.class.slot_class.name} or #{self.class.name} instance (#{other.class.name} given)"
      end
      self.class.new add(other)
    end

    def -(other)
      unless other.is_a?(Range) || other.is_a?(Array) || other.class == self.class.slot_class || other.class == self.class
        raise ArgumentError, "Either subtract a Range, an Array, #{self.class.slot_class.name} or #{self.class.name} instance (#{other.class.name} given)"
      end
      self.class.new subtract(other)
    end

    def ==(other)
      ((self.class == other.class) || (other_is_an_array = other.is_a?(Array))) && begin
        range_slots.size == (other_range_slots = other_is_an_array ? other : other.range_slots).size && begin
          range_slots.each_with_index do |range_slot, index|
            return false unless range_slot == other_range_slots[index]
          end
          true
        end
      end
    end

  private

    def to_range_slots(ranges_or_range_slots)
      ranges_or_range_slots.flatten.collect do |range_or_range_slot|
        if range_or_range_slot.class == self.class.slot_class
          range_or_range_slot
        elsif range_or_range_slot.is_a?(Range)
          self.class.slot_class.new range_or_range_slot
        else
          raise ArgumentError
        end
      end.sort do |a, b|
        [a.start, a.end] <=> [b.start, b.end]
      end
    end

    def to_ranges(object)
      begin
        if object.is_a?(Range) || object.class == self.class.slot_class
          [object]
        elsif object.class == self.class
          object.range_slots
        else
          object
        end
      end.collect do |entry|
        if entry.class == self.class.slot_class
          entry.start..entry.end
        elsif entry.is_a?(Range)
          entry
        else
          raise ArgumentError
        end
      end
    end

    def add(other)
      *merged_ranges = (ranges = to_ranges(self).concat(to_ranges(other)).sort{|a, b| [a.first, a.last] <=> [b.first, b.last]}).shift
      ranges.each do |range|
        last_range = merged_ranges[-1]
        if last_range.last >= range.first - 1
          merged_ranges[-1] = last_range.first..[range.last, last_range.last].max
        else
          merged_ranges.push range
        end
      end
      merged_ranges
    end

    def subtract(other)
      divided_ranges = to_ranges(self)
      to_ranges(other).each do |range|
        divided_ranges = divided_ranges.collect do |divided_range|
          if range.first <= divided_range.first && range.last > divided_range.first && range.last < divided_range.last
            # | range |
            #     | divided_range |
            range.last..divided_range.last
          elsif range.first > divided_range.first && range.first < divided_range.last && range.last >= divided_range.last
            #             | range |
            # | divided_range |
            divided_range.first..range.first
          elsif range.first > divided_range.first && range.last < divided_range.last
            #     | range |
            # | divided_range |
            [divided_range.first..range.first, range.last..divided_range.last]
          elsif range.last <= divided_range.first || range.first >= divided_range.last
            # | range |
            #           | divided_range |
            # or
            #                   | range |
            # | divided_range |
            divided_range
          end
        end.flatten.compact
      end
      divided_ranges
    end

  end
end