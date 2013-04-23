# SlotMachine [![Build Status](https://secure.travis-ci.org/archan937/slot_machine.png)](http://travis-ci.org/archan937/slot_machine)

Ruby gem for matching available slots (time slots are also supported)

## Introduction

One of the classic programming problems is the determination of time slot availability. Very often this is used within scheduling / calendar programs. SlotMachine is a very small Ruby gem which can do the job for you. It does not only focuses on time slots, but also slots in general.

## Installation

### Add `SlotMachine` to your Gemfile

    gem "slot_machine"

### Install the gem dependencies

    $ bundle

## Usage

### SlotMachine::Slot module

The core implementation of SlotMachine is written in `SlotMachine::Slot`. A module which has to be included within a Ruby class.
SlotMachine provides the classes `Slot` and `TimeSlot` of which `Slot` is defined as follows:

    class Slot
      include SlotMachine::Slot
    end

Clean and simple. Cool, huh? `TimeSlot` also includes the `SlotMachine::Slot` module and overrides a few methods to provide time slot specific behaviour.

### Slot

`SlotMachine` is pretty straightforward. A slot consists of a start and an end (integer) value. You can define a slot as follows:

    [1] pry(main)> s = Slot.new 0..20
    => #<Slot @start=0 @end=20>
    [2] pry(main)> s.start
    => 0
    [3] pry(main)> s.end
    => 20

After having defined a slot, you can match available slots within that slot. Let's say that you want to calculate available slots with a length of `10`:

    [4] pry(main)> s.match 10
    => [#<Slot @start=0 @end=10>, #<Slot @start=10 @end=20>]

The `match` method returns an array with the available slots. At default, the `Slot` searches for slots with an interval size of `10` and thus `0..10` and `10..20` are matched.

You can change the interval by passing it as a second argument. Using an interval size of `2`:

    [5] pry(main)> s.match 10, 2
    => [#<Slot @start=0 @end=10>,
     #<Slot @start=2 @end=12>,
     #<Slot @start=4 @end=14>,
     #<Slot @start=6 @end=16>,
     #<Slot @start=8 @end=18>,
     #<Slot @start=10 @end=20>]

You can also match a slot with another slot instance. This returns the slot in which both slots overlap each other:

    [5] pry(main)> s.match 15..30 #=> you can also use: s.match Slot.new(15..30)
    => [#<Slot @start=15 @end=20>]
    [6] s.match Slot.new(21..30) #=> no overlap
    => []

### TimeSlot

The `TimeSlot` class is (of course) similar to the `Slot` class, but accepts military times (e.g. 1300 for 1:00 pm). In other words, it only counts from `0` untill `59` within a `0` to `99` range. Also, the default interval size is `15`.

An example:

    [1] pry(main)> ts = TimeSlot.new 1015..1045
    => #<TimeSlot @start=1015 @end=1045>
    [2] pry(main)> ts.match 10
    => [#<TimeSlot @start=1015 @end=1025>, #<TimeSlot @start=1030 @end=1040>]
    [3] pry(main)> ts.match 10, 5
    => [#<TimeSlot @start=1015 @end=1025>,
     #<TimeSlot @start=1020 @end=1030>,
     #<TimeSlot @start=1025 @end=1035>,
     #<TimeSlot @start=1030 @end=1040>,
     #<TimeSlot @start=1035 @end=1045>]
    [4] pry(main)> ts.match 1038..1100 #=> you can also use: ts.match TimeSlot.new(1038..1100)
    => [#<TimeSlot @start=1038 @end=1045>]

## Using the console

The SlotMachine repo is provided with `script/console` which you can use for development / testing purposes.

Run the following command in your console:

    $ script/console
    Loading development environment (SlotMachine 0.1.0)
    [1] pry(main)> s = Slot.new 0..25
    => #<Slot @start=0 @end=25>
    [2] pry(main)> s.match 15
    => [#<Slot @start=0 @end=15>, #<Slot @start=10 @end=25>]
    [3] pry(main)> s.match 10, 4
    => [#<Slot @start=0 @end=10>,
     #<Slot @start=4 @end=14>,
     #<Slot @start=8 @end=18>,
     #<Slot @start=12 @end=22>]
    [4] pry(main)> ts = TimeSlot.new 1015..1045
    => #<TimeSlot @start=1015 @end=1045>
    [5] pry(main)> ts.match 10
    => [#<TimeSlot @start=1015 @end=1025>, #<TimeSlot @start=1030 @end=1040>]
    [6] pry(main)> ts.match 10, 5
    => [#<TimeSlot @start=1015 @end=1025>,
     #<TimeSlot @start=1020 @end=1030>,
     #<TimeSlot @start=1025 @end=1035>,
     #<TimeSlot @start=1030 @end=1040>,
     #<TimeSlot @start=1035 @end=1045>]

## Testing

Run the following command for testing:

    $ rake

You can also run a single test file:

    $ ruby test/unit/test_time_slot.rb

## Closing words

Well that's about it! Pretty straightforward, right? Have fun playing with the `SlotMachine`! ^^

## TODO

* Update documentation regarding Slots, TimeSlots and Time objects

## Contact me

For support, remarks and requests, please mail me at [paul.engel@holder.nl](mailto:paul.engel@holder.nl).

## License

Copyright (c) 2012 Paul Engel, released under the MIT license

[http://holder.nl](http://holder.nl) - [http://codehero.es](http://codehero.es) - [http://gettopup.com](http://gettopup.com) - [http://github.com/archan937](http://github.com/archan937) - [http://twitter.com/archan937](http://twitter.com/archan937) - [paul.engel@holder.nl](mailto:paul.engel@holder.nl)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.