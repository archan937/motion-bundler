require "motion-bundler/core_ext"
require "motion-bundler/gem_ext"
require "motion-bundler/config"
require "motion-bundler/require"
require "motion-bundler/version"

module MotionBundler
  extend self

  MOTION_BUNDLER_FILE = File.expand_path "./.motion-bundler.rb"

  def setup
    touch_motion_bundler
    trace_require do
      require MOTION_BUNDLER_FILE
      Bundler.require :motion
      default_files.each do |file|
        require file
      end
      if block_given?
        config = Config.new
        yield config
        config.requires.each{|file| require file, "APP"}
      end
    end
    write_motion_bundler
  end

  def trace_require
    Require.trace do
      yield
    end
    Motion::Project::App.setup do |app|
      app.files = begin
        Require.files + app.files - ["APP", "BUNDLER", __FILE__]
      end
      app.files_dependencies(
        Require.files_dependencies.tap do |dependencies|
          if app_files = dependencies.delete("APP")
            default_file = default_files.first
            dependencies[default_file] ||= []
            dependencies[default_file].concat app_files
          end
          (dependencies.delete("BUNDLER") || []).each do |file|
            dependencies[file] ||= []
            dependencies[file] = default_files + dependencies[file]
          end
          dependencies.delete(__FILE__)
        end
      )
    end
  end

  def simulator?
    !device?
  end

  def device?
    argv.include? "device"
  end

  def default_files
    [File.expand_path("../motion-bundler/#{simulator? ? "simulator" : "device"}/boot.rb", __FILE__)]
  end

private

  def argv
    ARGV
  end

  def touch_motion_bundler
    File.open(MOTION_BUNDLER_FILE, "w") {}
  end

  def write_motion_bundler
    File.open(MOTION_BUNDLER_FILE, "w") do |file|
      required = Require.requires.values.flatten
      file << <<-RUBY_CODE.gsub("        ", "")
        module MotionBundler
          REQUIRED = #{pretty_inspect required, 2}
        end
      RUBY_CODE
    end
  end

  def pretty_inspect(object, indent = 0)
    if object.is_a?(Array)
      entries = object.collect{|x| "  #{pretty_inspect x, indent + 2}"}
      return "[]" if entries.empty?
      entries.each_with_index{|x, i| entries[i] = "#{x}," if i < entries.size - 1}
      ["[", entries, "]"].flatten.join "\n" + (" " * indent)
    # elsif object.is_a?(Hash)
    #   entries = object.collect{|k, v| "  #{k.inspect} => #{pretty_inspect v, indent + 2}"}
    #   return "{}" if entries.empty?
    #   entries.each_with_index{|x, i| entries[i] = "#{x}," if i < entries.size - 1}
    #   ["{", entries, "}"].flatten.join "\n" + (" " * indent)
    else
      object.inspect
    end
  end

end