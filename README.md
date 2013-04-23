# MotionBundler

Use Ruby gems and mock require statements within RubyMotion applications

## Introduction

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.


## Installation

### Add MotionBundler to your Gemfile

    gem "motion-bundler"

### Install the gem dependencies

    $ bundle

## Usage

### Set up your `Gemfile` and `Rakefile`

You need to setup your `Gemfile` by separating RubyMotion aware Ruby gems from the ones that are not. Put the RubyMotion **unaware** gems in the `:motion` Bundler group like this:

    source "http://rubygems.org"

    # RubyMotion aware gems
    gem "motion-bundler"
    gem "easy-button"

    # RubyMotion unaware gems
    group :motion do
      gem "slot_machine"
    end

Add `MotionBundler.setup` at the end of your `Rakefile`:

    # -*- coding: utf-8 -*-

    # Use `rake config' to see complete project settings.
    $:.unshift "/Library/RubyMotion/lib"

    require "motion/project"
    require "bundler"
    Bundler.require

    Motion::Project::App.setup do |app|
      app.name = "MyMotionApp"
      app.frameworks << "AVFoundation"
    end

    MotionBundler.setup

Run `bundle install` if you haven't already and then `rake` to run the application in your iOS-simulator. Voila! You're done ^^

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## Contact me

For support, remarks and requests, please mail me at [paul.engel@holder.nl](mailto:paul.engel@holder.nl).

## License

Copyright (c) 2013 Paul Engel, released under the MIT license

[http://holder.nl](http://holder.nl) - [http://codehero.es](http://codehero.es) - [http://gettopup.com](http://gettopup.com) - [http://github.com/archan937](http://github.com/archan937) - [http://twitter.com/archan937](http://twitter.com/archan937) - [paul.engel@holder.nl](mailto:paul.engel@holder.nl)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.