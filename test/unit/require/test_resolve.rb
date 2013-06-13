require File.expand_path("../../../test_helper", __FILE__)

module Unit
  module Require
    class TestResolve < MiniTest::Unit::TestCase

      describe MotionBundler::Require::Resolve do

        module Require
          include MotionBundler::Require::Resolve
          extend self
        end

        it "should be able to resolve require paths" do
          MotionBundler::Require::Mocker.expects(:dirs).at_least_once.returns [
            MotionBundler::Require::Mocker::APP_MOCKS, mocks_dir, MotionBundler::Require::Mocker::GEM_MOCKS
          ]
          assert_equal "foo", Require.resolve("foo")
          assert_equal "#{mocks_dir}/yaml.rb", Require.resolve("yaml")
          assert_equal "#{mocks_dir}/net/http.rb", Require.resolve("net/http")
          assert_equal "#{mocks_dir}/net/http.rb", Require.resolve("net/http.rb")
          assert_equal "#{mocks_dir}/psych_foo-0.1.0/psych/handler.rb", Require.resolve("psych/handler")
          assert_equal "#{mocks_dir}/psych_foo-0.1.0/psych/handler.rb", Require.resolve("psych/handler")
          assert_equal "#{MotionBundler::Require::Mocker::GEM_MOCKS}/httparty.rb", Require.resolve("httparty")
        end

      end

    end
  end
end