# -*- encoding: utf-8 -*-
require File.expand_path("../lib/motion-bundler/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Paul Engel"]
  gem.email         = ["paul.engel@holder.nl"]
  gem.summary       = %q{Use Ruby gems and require statements within RubyMotion applications}
  gem.description   = %q{Use Ruby gems and require statements within RubyMotion applications}
  gem.homepage      = "https://github.com/archan937/motion-bundler"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "motion-bundler"
  gem.require_paths = ["lib"]
  gem.version       = MotionBundler::VERSION

  gem.add_development_dependency "minitest"
  gem.add_development_dependency "mocha"
  gem.add_development_dependency "rake"

  gem.add_dependency "colorize"
  gem.add_dependency "motion.h"
end