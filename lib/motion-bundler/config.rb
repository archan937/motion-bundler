module MotionBundler
  class Config
    def initialize
      @requires = []
      @files_dependencies = {}
    end
    def require(name)
      @requires << name
    end
    def register(files_dependencies)
      files_dependencies.each do |file, paths|
        (@files_dependencies[Require.resolve(file, false)] ||= []).concat paths.collect{|file| Require.resolve(file, false)}
      end
    end
    def files
      (@files_dependencies.keys + @files_dependencies.values).flatten.uniq
    end
    def files_dependencies
      @files_dependencies.dup
    end
    def requires
      @requires.dup
    end
  end
end