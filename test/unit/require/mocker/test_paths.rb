require File.expand_path("../../../../test_helper", __FILE__)

module Unit
  module Require
    module Mocker
      class TestPaths < MiniTest::Unit::TestCase

        module Mocker
          include MotionBundler::Require::Mocker::Paths
          extend self
        end

        describe MotionBundler::Require::Mocker::Paths do
          before do
            Mocker.send :remove_instance_variable, :@dirs if Mocker.instance_variables.include?(:@dirs)
          end

          it "should have mock dirs" do
            assert_equal [Mocker::APP_MOCKS, Mocker::GEM_MOCKS], Mocker.dirs
          end

          it "should be able to add mock dirs" do
            Mocker.add_dir mocks_dir
            assert_equal [Mocker::APP_MOCKS, mocks_dir, Mocker::GEM_MOCKS], Mocker.dirs
          end

          it "should be able to resolve require paths" do
            Mocker.add_dir mocks_dir
            assert_equal "foo", Mocker.resolve("foo")
            assert_equal "date", Mocker.resolve("date")
            assert_equal "#{mocks_dir}/yaml.rb", Mocker.resolve("yaml")
            assert_equal "#{mocks_dir}/net/http.rb", Mocker.resolve("net/http")
            assert_equal "#{mocks_dir}/net/http.rb", Mocker.resolve("net/http.rb")
            assert_equal "#{mocks_dir}/psych_foo-0.1.0/psych/handler.rb", Mocker.resolve("psych/handler")
            assert_equal "#{mocks_dir}/psych_foo-0.1.0/psych/handler.rb", Mocker.resolve("psych/handler")
            assert_equal "#{Mocker::GEM_MOCKS}/httparty.rb", Mocker.resolve("httparty")
          end
        end

      end
    end
  end
end