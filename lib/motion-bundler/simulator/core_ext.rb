module Kernel
  def require(name)
    puts "Require #{name.inspect} ignored"
  end
  #require_relative(string)
  #load(filename, wrap=false)
  #autoload(mod, filename)
end
class Module
  #autoload(mod, filename)
  #class_eval(*args, &block)
  #module_eval(*args, &block)
end
class Class
  #delegate(*args)
end
class Object
  def require(name)
    puts "Require #{name.inspect} ignored"
  end
  #instance_eval(*args, &block)
end