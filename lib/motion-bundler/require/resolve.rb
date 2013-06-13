module MotionBundler
  module Require
    module Resolve

      def resolve(path)
        base_path = path.gsub(/\.rb$/, "")

        load_paths.each do |load_path|
          if (file = Dir["#{load_path}/#{base_path}.rb"].first)
            return file
          end
        end

        path
      end

    private

      def load_paths
        Mocker.dirs + Mocker.dirs.collect_concat{|x| Dir["#{x}/*"]} + $LOAD_PATH + gem_paths
      end

      class GemPath
        attr_reader :name, :version, :path, :version_numbers
        include Comparable

        def initialize(path)
          @name, @version = File.basename(path).scan(/^(.+?)-([^-]+)$/).flatten
          @path = path
          @version_numbers = @version.split(/[^0-9]+/).collect(&:to_i)
        end

        def <=>(other)
          raise "Not comparable gem paths ('#{name}' is not '#{other.name}')" unless name == other.name
          @version_numbers <=> other.version_numbers
        end
      end

      def gem_paths
        @gem_paths ||= Dir["{#{::Gem.paths.path.join(",")}}" + "/gems/*"].inject({}) do |gem_paths, path|
          gem_path = GemPath.new path
          gem_paths[gem_path.name] ||= gem_path
          gem_paths[gem_path.name] = gem_path if gem_paths[gem_path.name] < gem_path
          gem_paths
        end.values.collect do |gem_path|
          gem_path.path + "/lib"
        end.sort
      end

    end
  end
end