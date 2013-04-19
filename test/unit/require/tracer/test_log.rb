require File.expand_path("../../../../test_helper", __FILE__)

module Unit
  module Require
    module Tracer
      class TestLog < MiniTest::Unit::TestCase

        describe MotionBundler::Require::Tracer::Log do
          before do
            @log = MotionBundler::Require::Tracer::Log.new
          end

          it "should be able to clear it's log" do
            @log.instance_variable_set :@log, {"a" => "b"}
            @log.clear
            assert_equal true, @log.instance_variable_get(:@log).empty?
          end

          it "should register dependencies as expected" do
            loaded_features = %w(foo1 foo2 foo3)
            @log.expects(:loaded_features).at_least_once.returns loaded_features
            @log.instance_variable_set :@log, {"file1" => ["file0"]}

            @log.register "file1" do
              loaded_features << "file2"
              @log.register "file2" do
                loaded_features << "file3"
                @log.register "file2" do
                  loaded_features << "file4"
                end
              end
            end

            assert_equal({
              "file1" => %w(file0 file2),
              "file2" => %w(file3 file4)
            }, @log.instance_variable_get(:@log))
          end
        end

      end
    end
  end
end