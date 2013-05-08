module MotionBundler
  class Config
    def initialize
      @requires = []
    end
    def require(name)
      @requires << name
    end
    def requires
      @requires.dup
    end
  end
end