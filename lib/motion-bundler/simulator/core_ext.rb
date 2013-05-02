module Kernel
  def require(name)
    puts "Require #{name.inspect} ignored"
  end
  def require_relative(string)
    puts "Relative require #{string.inspect} ignored"
  end
  def load(filename, wrap=false)
    puts "Load #{filename.inspect} ignored"
  end
  def autoload(mod, filename)
    puts "Autoload #{filename.inspect} ignored"
  end
end
class Module
  def autoload(mod, filename)
    puts "Autoload #{filename.inspect} ignored"
  end
  alias :original_class_eval :class_eval
  def class_eval(*args, &block)
    if block_given?
      original_class_eval &block
    else
      puts "Class eval ignored"
    end
  end
  alias :original_module_eval :module_eval
  def module_eval(*args, &block)
    if block_given?
      original_module_eval &block
    else
      puts "Module eval ignored"
    end
  end
end
class Object
  def require(name)
    puts "Require #{name.inspect} ignored"
  end
  alias :original_instance_eval :instance_eval
  def instance_eval(*args, &block)
    if block_given?
      original_instance_eval &block
    else
      puts "Instance eval ignored"
    end
  end
end