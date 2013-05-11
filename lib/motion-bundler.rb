require "bundler"
require "motion-bundler/gem_ext"
require "motion-bundler/config"
require "motion-bundler/require"
require "motion-bundler/version"

module MotionBundler
  extend self

  MOTION_BUNDLER_FILE = File.expand_path "./.motion-bundler.rb"

  def setup(&block)
    Motion::Project::App.setup do |app|
      touch_motion_bundler

      files, files_dependencies, required = app.files, {}, []
      ripper_require files, files_dependencies, required
      tracer_require files, files_dependencies, required, &block
      app.files = files
      app.files_dependencies files_dependencies

      write_motion_bundler files, files_dependencies, required
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

  def ripper_require(files, files_dependencies, required)
    ripper = Require::Ripper.new *Dir["app/**/*.rb"].collect{|x| "./#{x}"}
    files.concat ripper.files
    files_dependencies.merge! ripper.files_dependencies
    required.concat ripper.requires.values.flatten
  end

  def tracer_require(files, files_dependencies, required)
    Require.trace do
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

    files.replace(
      (Require.files + files - ["APP", "BUNDLER", __FILE__]).uniq
    )
    files_dependencies.merge!(
      Require.files_dependencies.tap do |dependencies|
        if app_dependencies = dependencies.delete("APP")
          default_file = default_files.first
          dependencies[default_file] ||= []
          dependencies[default_file].concat app_dependencies
        end
        (dependencies.delete("BUNDLER") || []).each do |file|
          dependencies[file] ||= []
          dependencies[file] = default_files + dependencies[file]
        end
        dependencies.delete(__FILE__)
      end
    )
    required.concat Require.requires.values.flatten

    true
  end

  def write_motion_bundler(files, files_dependencies, required)
    File.open(MOTION_BUNDLER_FILE, "w") do |file|
      files_dependencies = files_dependencies.dup.tap do |dependencies|
        if motion_bundler_dependencies = dependencies.delete(__FILE__)
          dependencies["MOTION_BUNDLER"] = motion_bundler_dependencies
        end
      end
      file << <<-RUBY_CODE.gsub("        ", "")
        module MotionBundler
          FILES = #{pretty_inspect files, 2}
          FILES_DEPENDENCIES = #{pretty_inspect files_dependencies, 2}
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
    elsif object.is_a?(Hash)
      entries = object.collect{|k, v| "  #{k.inspect} => #{pretty_inspect v, indent + 2}"}
      return "{}" if entries.empty?
      entries.each_with_index{|x, i| entries[i] = "#{x}," if i < entries.size - 1}
      ["{", entries, "}"].flatten.join "\n" + (" " * indent)
    else
      object.inspect
    end
  end

end