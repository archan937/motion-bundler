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
            @log.instance_variable_set :@log, {"/Sources/lib/file1.rb" => ["file0"]}

            @log.register "/Sources/lib/file1.rb:129" do
              loaded_features << "file2"
              @log.register "/Sources/lib/file2.rb:1" do
                loaded_features << "file3"
                @log.register "/Sources/lib/file2.rb:2" do
                  loaded_features << "file4"
                end
                @log.register "/Sources/lib/file2" do
                  loaded_features << "file5"
                end
              end
            end

            assert_equal({
              "/Sources/lib/file1.rb" => %w(file0 file2),
              "/Sources/lib/file2.rb" => %w(file3 file4)
            }, @log.instance_variable_get(:@log))
          end
        end

      end
    end
  end
end