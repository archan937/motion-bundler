require "stringio"
require "strscan"
require "zlib"

class AppController < UIViewController
  def viewDidLoad

    # Testing SlotMachine
    ts = TimeSlot.new 1015..1045
    p ts.match 10
    p ts.match 10, 5

    # Testing StringIO

    s = StringIO.new %{This is a test of a string as a file.\r\nAnd this could be another line in the file}
    p s.gets
    p s.read(17)

    # Testing StringScanner
    s = StringScanner.new "ab"
    p s.getch
    p s.getch
    p s.getch

    # Testing Zlib

    data = "x\234\355\301\001\001\000\000\000\200\220\376\257\356\b\n#{"\000" * 31}\030\200\000\000\001"
    zipped = Zlib::Inflate.inflate data
    p zipped == ("\000" * 32 * 1024)

  end
end