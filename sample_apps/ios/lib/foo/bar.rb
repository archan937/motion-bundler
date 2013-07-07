require "cgi"

module Foo
  module Bar
    def self.bar!
      CGI.escape_html "Bar < Foo"
    end
  end
end