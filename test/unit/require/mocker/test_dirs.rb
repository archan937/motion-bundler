require File.expand_path("../../../../test_helper", __FILE__)

module Unit
  module Require
    module Mocker
      class TestDirs < MiniTest::Unit::TestCase

        module Mocker
          include MotionBundler::Require::Mocker::Dirs
          extend self
        end

        describe MotionBundler::Require::Mocker::Dirs do
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
        end

      end
    end
  end
end