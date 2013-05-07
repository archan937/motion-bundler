unless ENV["MB_SILENCE_CORE"] == "false"

module Kernel
  def console
    defined?(MotionBundler::Simulator) ? MotionBundler::Simulator::Console : Class.new{ def warn(*args); end }.new
  end
end

class Object
  def require(name)
    console.warn "require \"#{name}\"", caller
  end
  def require_relative(string)
    console.warn "require_relative \"#{string}\"", caller
  end
  def load(filename, wrap=false)
    console.warn "load \"#{filename}\"", caller
  end
  alias :original_instance_eval :instance_eval
  def instance_eval(*args, &block)
    if block_given?
      original_instance_eval &block
    else
      console.warn self.class.name, :instance_eval, caller
    end
  end
end

class Module
  def autoload(mod, filename)
    console.warn "autoload :#{mod}, \"#{filename}\"", caller
  end
  alias :original_class_eval :class_eval
  def class_eval(*args, &block)
    if block_given?
      original_class_eval &block
    else
      console.warn name, :class_eval, caller
    end
  end
  alias :original_module_eval :module_eval
  def module_eval(*args, &block)
    if block_given?
      original_module_eval &block
    else
      console.warn name, :module_eval, caller
    end
  end
end

end