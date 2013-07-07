unless ENV["MB_SILENCE_CORE"] == "false"

module Kernel
  def require(name)
  end
  def require_relative(string)
  end
  def load(*args)
  end
  def autoload(mod, filename)
  end
end

class Object
  def require(name)
  end
  def require_relative(string)
  end
  def load(*args)
  end
end

class Module
  def autoload(mod, filename)
  end
end

end