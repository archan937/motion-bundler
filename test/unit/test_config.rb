require File.expand_path("../../test_helper", __FILE__)

module Unit
  class TestConfig < MiniTest::Unit::TestCase

    describe MotionBundler::Config do
      it "should include 'boot.rb' when existing" do
        assert_equal({}, MotionBundler::Config.new.files_dependencies)
        MotionBundler::Config.any_instance.expects(:boot_file?).returns true
        assert_equal({"app/app_delegate.rb" => ["boot.rb"]}, MotionBundler::Config.new.files_dependencies)
      end

      it "should be able to register requires and returning them" do
        config = MotionBundler::Config.new
        assert_equal [], config.requires

        config.require "foo"
        config.require "foo/baz"
        assert_equal %w(foo foo/baz), config.requires
        assert config.requires.object_id != config.requires.object_id

        cgi = MotionBundler::Require.resolve "cgi", false
        html = MotionBundler::Require.resolve "cgi/html", false

        config.register({"cgi" => ["cgi/html"]})
        assert_equal([cgi, html], config.files)
        assert_equal({cgi => [html]}, config.files_dependencies)

        cookie = MotionBundler::Require.resolve "cgi/cookie", false

        config.instance_variable_get(:@files_dependencies)[cgi].expects(:concat).with([cookie])
        config.register({"cgi" => ["cgi/cookie"]})
      end
    end

  end
end