require_relative "foo/bar"
require "cgi"

module Foo
  def self.foo!
    CGI.escape_html "Foo > Bar"
  end
end