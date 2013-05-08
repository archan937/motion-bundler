require File.expand_path("../../test_helper", __FILE__)

module Unit
  class TestConfig < MiniTest::Unit::TestCase

    describe MotionBundler::Config do
      it "should be able to register requires and returning them" do
        config = MotionBundler::Config.new
        assert_equal [], config.requires

        config.require "foo"
        config.require "foo/baz"
        assert_equal %w(foo foo/baz), config.requires

        assert config.requires.object_id != config.requires.object_id
      end
    end

  end
end