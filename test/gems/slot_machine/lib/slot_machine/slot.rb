module SlotMachine
  module Slot

    def self.included(base)
      base.class_eval do
        attr_reader :start, :end, :length

        def self.interval(value)
          @interval = value
        end

        def self.default_interval
          @interval || 10
        end

        def self.slots_class
          @slots_class ||= "#{name}s".split("::").inject(Object) do |mod, name|
            mod.const_get name
          end
        end
      end
    end

    def initialize(range_or_length)
      if range_or_length.is_a? Range
        @type = :range
        self.start = range_or_length.first
        self.end   = range_or_length.last
      else
        @type = :length
        self.length = range_or_length
      end
    end

    def range?
      @type == :range
    end

    def length?
      @type == :length
    end

    def start=(value)
      @start = start!(value) if range?
    end

    def end=(value)
      @end = end!(value) if range?
    end

    def length=(value)
      @length = length!(value) if length?
    end

    def match(other, interval = nil)
      interval ||= self.class.default_interval
      raise ArgumentError, "Interval has to be greater than 0 (#{interval} given)" unless interval > 0
      unless self.class == other.class
        other = self.class.new other
      end
      match_compared to_compared, other.to_compared, interval
    end

    def +(other)
      self.class.slots_class.new(self) + other
    end

    def -(other)
      self.class.slots_class.new(self) - other
    end

    def ==(other)
      self.class == other.class && self.start == other.start && self.end == other.end && self.length == other.length
    end

    def inspect
      inspect_variables = begin
        if range?
          "@start=#{@start} @end=#{@end}"
        else
          "@length=#{@length}"
        end
      end
      "#<#{self.class.name} #{inspect_variables}>"
    end

  protected

    def typecast(value)
      value.to_s
    end

    def valid?(value)
      true
    end

    def to_compared
      if range?
        to_array
      else
        @length
      end
    end

    def to_array
      (@start..@end).to_a.tap do |array|
        array.pop
      end
    end

    def from_array(array)
      self.class.new array.first..(add(array.last, 1))
    end

    def add(a, b)
      a + b
    end

  private

    def start!(value)
      valid! abs!(lt!(value, @end))
    end

    def end!(value)
      valid! abs!(gt!(value, @start))
    end

    def length!(value)
      abs! value
    end

    def gt!(value, compared)
      typecast! value, :>, compared
    end

    def lt!(value, compared)
      typecast! value, :<, compared
    end

    def abs!(value)
      typecast! value, :>=, 0
    end

    def typecast!(value, operator, compared)
      Integer(typecast(value)).tap do |value|
        raise ArgumentError, "Passed value should be #{operator} #{compared} (#{value} given)" if compared && !value.send(operator, compared)
      end
    end

    def valid!(value)
      raise ArgumentError, "Passed value is invalid (#{value} given)" unless valid?(value)
      value
    end

    def match_compared(a, b, interval)
      if a.is_a?(Array) && b.is_a?(Fixnum)
        raise ArgumentError, "Length has to be greater than 0 (#{b} given)" unless b > 0
        i = 0
        [].tap do |matches|
          while (a.size / b) > 0
            matches << from_array(a[0, b])
            a.shift interval
            i += interval
          end
        end
      elsif a.is_a?(Fixnum) && b.is_a?(Array)
        match_compared b, a, interval
      elsif a.is_a?(Array) && b.is_a?(Array)
        [].tap do |matches|
          unless (array = a & b).empty?
            matches << from_array(array)
          end
        end
      else
        raise ArgumentError, "Cannot match when passing two length slots"
      end
    end

  end
end