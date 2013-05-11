require File.expand_path("../../../../test_helper", __FILE__)

module Unit
  module Require
    module Ripper
      class TestBuilder < MiniTest::Unit::TestCase

        describe MotionBundler::Require::Ripper::Builder do
          it "should scan for requires" do
            File.expects(:read).with("./app/controllers/app_controller.rb").returns <<-RUBY_CODE
              require "foo"
              require_relative "bar"
              class AppController
                require "qux"
                def bar
                  puts "Bar!"
                end
              end
            RUBY_CODE
            builder = MotionBundler::Require::Ripper::Builder.new "./app/controllers/app_controller.rb"
            assert_equal [
              [:require, ["foo"]],
              [:require_relative, ["bar"]],
              [:require, ["qux"]]
            ], builder.requires
          end
        end

      end
    end
  end
end