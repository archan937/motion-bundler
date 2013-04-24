require File.expand_path("../../test_helper", __FILE__)

module Unit
  class TestGemExt < MiniTest::Unit::TestCase

    describe "lib/motion-bundler/gem_ext.rb" do
      it "should required after having required MotionBundler" do
        assert_equal true, $LOADED_FEATURES.include?(File.expand_path "../../../lib/motion-bundler/gem_ext.rb", __FILE__)
      end

      it "should override Motion::Project::Config#files_dependencies in order to tackle absolute paths" do
        config = Motion::Project::Config.new
        config.instance_variable_set :@files, %w(/Users/paulengel/foo.rb /Users/paulengel/bar.rb /Users/paulengel/fubar.rb)
        config.instance_variable_set :@dependencies, Hash.new
        assert config.files_dependencies("/Users/paulengel/foo.rb" => %w(/Users/paulengel/bar.rb))
        assert_raises RuntimeError do
          config.files_dependencies "foo" => %w(bar.rb)
        end
      end
    end

  end
end