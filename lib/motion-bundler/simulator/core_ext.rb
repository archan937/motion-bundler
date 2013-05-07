unless ENV["MB_SILENCE_CORE"] == "false"

module Kernel
  def console
    defined?(MotionBundler::Simulator) ? MotionBundler::Simulator::Console : Class.new{ def warn(*args); end }.new
  end
end

class Object
  def require(name)
    console.warn do
      require name
    end
  end
  def require_relative(string)
    console.warn do
      require_relative string
    end
  end
  def load(filename, wrap=false)
    console.warn do
      load filename
    end
  end
  alias :original_instance_eval :instance_eval
  def instance_eval(*args, &block)
    if block_given?
      original_instance_eval &block
    else
      console.warn do
        object self.class.name
        method :instance_eval
      end
    end
  end
end

class Module
  def autoload(mod, filename)
    console.warn do
      autoload mod, filename
    end
  end
  alias :original_class_eval :class_eval
  def class_eval(*args, &block)
    if block_given?
      original_class_eval &block
    else
      console.warn do
        object name
        method :class_eval
      end
    end
  end
  alias :original_module_eval :module_eval
  def module_eval(*args, &block)
    if block_given?
      original_module_eval &block
    else
      console.warn do
        object name
        method :module_eval
      end
    end
  end
end

end