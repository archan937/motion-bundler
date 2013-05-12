# MotionBundler [![Build Status](https://secure.travis-ci.org/archan937/motion-bundler.png)](http://travis-ci.org/archan937/motion-bundler)

Use Ruby gems and mock require statements within RubyMotion applications

## Introduction

[RubyMotion](http://www.rubymotion.com) has united two great programming communities: the Ruby and iOS community. We are no longer forced to develop native iOS applications (for iPhone and iPad) using Objective-C and XCode anymore because we can choose using Ruby with any kind of text editor. Ruby gives us a lot of benefits like the beauty and flexibility of the language. Also, the Ruby community is driven by its enormous amount of open source libraries which are packed as so called "Ruby gems". Bundler is the Ruby standard for managing all the gem dependencies used within a Ruby project.

There are limitations though as you cannot use any random Ruby gem you want to. It either has to be RubyMotion aware (like [BubbleWrap](https://github.com/rubymotion/BubbleWrap)) or RubyMotion compatible (mostly when having as minimal gem dependencies as possible and not doing fancy Ruby stuff like code evaluation). Also, you cannot just require Ruby sources at runtime. You will have to specify them along with their mutual dependencies.

This can give us a lot of headaches and so I have created a Ruby gem called `MotionBundler`. It will unobtrusively track and specify the required Ruby sources and their mutual dependencies of Ruby gems you want to use in your RubyMotion application.

## Usage

### Set up your Gemfile and Rakefile

You need to setup your `Gemfile` by separating RubyMotion aware Ruby gems from the ones that are not. Put the RubyMotion **unaware** gems in the `:motion` Bundler group like this:

    source "http://rubygems.org"

    # RubyMotion aware gems
    gem "motion-bundler"

    # RubyMotion unaware gems
    group :motion do
      gem "slot_machine"
    end

Add `MotionBundler.setup` at the end of your `Rakefile`:

    # -*- coding: utf-8 -*-
    $:.unshift "/Library/RubyMotion/lib"
    require "motion/project"

    # Require and prepare Bundler
    require "bundler"
    Bundler.require

    Motion::Project::App.setup do |app|
      # Use `rake config' to see complete project settings.
      app.name = "SampleApp"
    end

    # Track and specify files and their mutual dependencies within the :motion Bundler group
    MotionBundler.setup

Run `bundle` and then `rake` to run the application in your iOS-simulator. Voila! You're done ^^

## More documentation

Please consult the [GitHub repository Wiki pages](https://github.com/archan937/motion-bundler/wiki/Overview) for further information about MotionBundler.

## Huh? Haven't you written LockOMotion already?

Yes, I did. But MotionBundler ...

* is an improved rewrite of [LockOMotion](https://github.com/archan937/lock-o-motion)
* has been stripped down
* has more code abstraction (and thus has much cleaner and readable code)
* has a [test coverage percentage of 100%](https://travis-ci.org/archan937/motion-bundler)

## Contact me

For support, remarks and requests, please mail me at [paul.engel@holder.nl](mailto:paul.engel@holder.nl).

## License

Copyright (c) 2013 Paul Engel, released under the MIT license

[http://holder.nl](http://holder.nl) - [http://codehero.es](http://codehero.es) - [http://gettopup.com](http://gettopup.com) - [http://github.com/archan937](http://github.com/archan937) - [http://twitter.com/archan937](http://twitter.com/archan937) - [paul.engel@holder.nl](mailto:paul.engel@holder.nl)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.