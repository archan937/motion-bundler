module Kernel
  def require(name)
  end
  def require_relative(string)
  end
  def load(filename, wrap=false)
  end
  def autoload(mod, filename)
  end
end
class Module
  def autoload(mod, filename)
  end
end
class Object
  def require(name)
  end
end