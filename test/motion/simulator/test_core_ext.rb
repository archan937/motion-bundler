require File.expand_path("../../../test_helper", __FILE__)

module Motion
  module Simulator
    class TestCoreExt < MiniTest::Unit::TestCase

      class Foo; end
      class Fu; end

      describe "lib/motion-bundler/simulator/core_ext.rb" do
        before do
          ENV["MB_SILENCE_CORE"] = "true"
        end

        it "should ignore require statements with a warning" do
          MotionBundler.expects(:simulator?).returns true
          last_loaded_feature = nil
          fu = Fu.new

          MotionBundler.default_files.each do |default_file|
            require default_file
          end

          last_loaded_feature = $LOADED_FEATURES.last

          assert_nil require("a")
          assert_nil require_relative("../../lib/a")
          assert_nil load("../../lib/a.rb")

          class Foo
            autoload :A, "../../lib/a.rb"
          end

          Foo.module_eval "def bar; end"
          Foo.module_eval do
            def baz
            end
          end

          Fu.class_eval "def bar; end"
          Fu.class_eval do
            def baz
            end
          end

          fu.instance_eval "def qux; end"
          fu.instance_eval do
            def quux
            end
          end

          assert_equal last_loaded_feature, $LOADED_FEATURES.last
          assert_raises NameError do
            A
          end
          assert_raises NameError do
            Foo::A
          end

          assert_equal false, Foo.new.respond_to?(:bar)
          assert_equal true , Foo.new.respond_to?(:baz)
          assert_equal false, Fu.new.respond_to?(:bar)
          assert_equal true , Fu.new.respond_to?(:baz)
          assert_equal false, fu.respond_to?(:qux)
          assert_equal true , fu.respond_to?(:quux)
        end
      end

    end
  end
end