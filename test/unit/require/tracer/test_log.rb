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
            @log.instance_variable_set :@requires, {"c" => "d"}
            @log.clear
            assert_equal true, @log.instance_variable_get(:@log).empty?
            assert_equal true, @log.instance_variable_get(:@requires).empty?
          end

          it "should register dependencies as expected" do
            loaded_features = %w(foo1 foo2 foo3)
            @log.expects(:loaded_features).at_least_once.returns loaded_features

            @log.instance_variable_set :@log, {"/Sources/lib/file1.rb" => ["file0"]}
            @log.instance_variable_set :@requires, {"/Sources/lib/file1.rb:47" => ["file0"]}

            @log.register "/.rvm/gems/bundler/bundler.rb:63", "foo" do
              @log.register "/Sources/lib/file1.rb:129:in `<module:Foo>'", "file2" do
                @log.register "/Sources/lib/file2.rb:1", "file3" do
                  @log.register "/Sources/lib/file2.rb:2", "file4" do
                    loaded_features << "file4"
                  end
                  loaded_features << "file3"
                end
                loaded_features << "file2"
              end
              @log.register "/Sources/lib/foo.rb:12", "qux" do
                {:required => false}
              end
              loaded_features << "file1"
            end

            assert_equal({
              "BUNDLER" => %w(file1),
              "/Sources/lib/file1.rb" => %w(file0 file2),
              "/Sources/lib/file2.rb" => %w(file3 file4)
            }, @log.instance_variable_get(:@log))

            assert_equal %w(
              /Sources/lib/file1.rb
              /Sources/lib/file2.rb
              BUNDLER
              file0
              file1
              file2
              file3
              file4
            ), @log.files

            assert_equal true, @log.files_dependencies.object_id != @log.instance_variable_get(:@log).object_id
            assert_equal true, @log.requires.object_id != @log.instance_variable_get(:@requires).object_id

            assert_equal({
              "BUNDLER" => %w(file1),
              "/Sources/lib/file1.rb" => %w(file0 file2),
              "/Sources/lib/file2.rb" => %w(file3 file4)
            }, @log.files_dependencies)

            assert_equal({
              "BUNDLER" => %w(foo),
              "/Sources/lib/file1.rb:47" => %w(file0),
              "/Sources/lib/file1.rb:129" => %w(file2),
              "/Sources/lib/file2.rb:1" => %w(file3),
              "/Sources/lib/file2.rb:2" => %w(file4),
              "/Sources/lib/foo.rb:12" => %w(qux)
            }, @log.requires)
          end
        end

      end
    end
  end
end