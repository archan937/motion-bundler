module Kernel
  def require(name)
    puts "Require #{name.inspect} ignored"
  end
end
class Object
  def require(name)
    puts "Require #{name.inspect} ignored"
  end
end