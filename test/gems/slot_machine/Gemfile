source "http://rubygems.org"

gemspec

group :gem_default do
  gem "slot_machine", :path => "."
end

group :gem_development do
  gem "pry"
end

group :gem_test do
  gem "minitest"
  gem "mocha", :git => "git://github.com/freerange/mocha.git", :ref => "f88a78050af1f1ad98c917cb26ed3539e59fe7e0" # see also: https://github.com/freerange/mocha/issues/93
  gem "pry"
  gem "rake"
end