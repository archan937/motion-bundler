unless ENV["MB_SILENCE_CORE"] == "false"

module Kernel
  def console
    defined?(MotionBundler::Simulator) ? MotionBundler::Simulator::Console : Class.new{ def warn(*args); end }.new
  end
end

class Object
  def require(name)
    console.warn { require name }
  end
  def require_relative(string)
    console.warn { require_relative string }
  end
  def load(*args)
    console.warn { load args[0] }
  end
  alias :original_instance_eval :instance_eval
  def instance_eval(*args, &block)
    if block_given?
      original_instance_eval &block
    else
      console.warn { call self.class.name, :instance_eval }
    end
  end
end

class Module
  def autoload(mod, filename)
    console.warn { autoload mod, filename }
  end
  alias :original_class_eval :class_eval
  def class_eval(*args, &block)
    if block_given?
      original_class_eval &block
    else
      console.warn { call name, :class_eval }
    end
  end
  alias :original_module_eval :module_eval
  def module_eval(*args, &block)
    if block_given?
      original_module_eval &block
    else
      console.warn { call name, :module_eval }
    end
  end
end

end

class String
  def yellow
    colorize 33
  end
  def green
    colorize 32
  end
  def red
    colorize 31
  end
private
  def colorize(color)
    "\e[0;#{color};49m#{self}\e[0m"
  end
end