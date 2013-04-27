module Kernel
  def require(name)
  end
  #require_relative(string)
  #load(filename, wrap=false)
  #autoload(mod, filename)
end
class Module
  #autoload(mod, filename)
end
class Class
  #delegate(*args)
end
class Object
  def require(name)
  end
end