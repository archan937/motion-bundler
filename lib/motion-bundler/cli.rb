require "yaml"
require "thor"
require "motion-bundler"

$CLI = true

module MotionBundler
  class CLI < Thor

    default_task :trace

    desc "trace [FILE]", "Trace files and their mutual dependencies when requiring [FILE]"
    def trace(file)
      Require.mock_and_trace do
        require file, "APP"
      end
      puts YAML.dump({
        "FILES" => Require.files,
        "FILES_DEPENDENCIES" => Require.files_dependencies,
        "REQUIRES" => Require.requires
      })
    end

  private

    def method_missing(method, *args)
      raise Error, "Unrecognized command \"#{method}\". Please consult `motion-bundler help`."
    end

  end
end