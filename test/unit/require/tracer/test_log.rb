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
              @log.register "/Sources/lib/file2.rb:1" do
                @log.register "/Sources/lib/file2.rb:2" do
                  loaded_features << "file4"
                end
                loaded_features << "file3"
              end
              loaded_features << "file2"
            end

            assert_equal({
              "/Sources/lib/file1.rb" => %w(file0 file2),
              "/Sources/lib/file2.rb" => %w(file3 file4)
            }, @log.instance_variable_get(:@log))
          end

          it "should return files and files_dependencies as expected" do
            @log.instance_variable_set :@log, {
              "/Sources/lib/file1.rb" => %w(file0 file2),
              "/Sources/lib/file2.rb" => %w(file3 file4)
            }

            assert_equal %w(/Sources/lib/file1.rb /Sources/lib/file2.rb file0 file2 file3 file4), @log.files
            assert_equal({
              "/Sources/lib/file1.rb" => %w(file0 file2),
              "/Sources/lib/file2.rb" => %w(file3 file4)
            }, @log.files_dependencies)

            assert_equal true, @log.files_dependencies.object_id != @log.instance_variable_get(:@log).object_id
          end
        end

      end
    end
  end
end