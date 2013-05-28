require_relative "foo/bar"
require_relative './../app/controllers/app_controller'
require "cgi"

module Foo
  def self.foo!
    CGI.escape_html "Foo > Bar"
  end
end