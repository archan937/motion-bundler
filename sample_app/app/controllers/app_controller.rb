require "stringio"
require "strscan"
require "zlib"
require "httparty"
require "net/pop"
require "rexml/document"
require "socket"

require_relative "../../lib/foo"

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

    # Testing (mocked) HTTParty

    p HTTParty.hi!

    # Testing (mocked) Net::Protocol

    p Net::Protocol.hi!

    # Testing Foo and Foo::Bar

    p Foo.foo!
    p Foo::Bar.bar!

    # Testing at runtime require statement

    file = "base64"
    require file
    enc = Base64.encode64("Send reinforcements!")
    p enc
    p Base64.decode64(enc)

    # Testing REXML::Document

    xml = <<-XML
      <inventory title="OmniCorp Store #45x10^3">
        <section name="health">
          <item upc="123456789" stock="12">
            <name>Invisibility Cream</name>
            <price>14.50</price>
            <description>Makes you invisible</description>
          </item>
          <item upc="445322344" stock="18">
            <name>Levitation Salve</name>
            <price>23.99</price>
            <description>Levitate yourself for up to 3 hours per application</description>
          </item>
        </section>
        <section name="food">
          <item upc="485672034" stock="653">
            <name>Blork and Freen Instameal</name>
            <price>4.95</price>
            <description>A tasty meal in a tablet; just add water</description>
          </item>
          <item upc="132957764" stock="44">
            <name>Grob winglets</name>
            <price>3.56</price>
            <description>Tender winglets of Grob. Just add water</description>
          </item>
        </section>
      </inventory>
    XML

    doc = REXML::Document.new xml
    root = doc.root

    doc.elements.each("inventory/section"){|element| puts element.attributes["name"]}
    # => health
    # => food
    doc.elements.each("*/section/item"){|element| puts element.attributes["upc"]}
    # => 123456789
    # => 445322344
    # => 485672034
    # => 132957764

    puts root.attributes["title"]
    # => OmniCorp Store #45x10^3
    puts root.elements["section/item[@stock='44']"].attributes["upc"]
    # => 132957764
    puts root.elements["section"].attributes["name"]
    # => health (returns the first encountered matching element)
    puts root.elements[1].attributes["name"]
    # => health (returns the FIRST child element)

    # Say thanks

    alert = UIAlertView.new
    alert.title = "Thanks!"
    alert.message = "Hi, thanks for giving MotionBundler a try! Any form of collaboration is very welcome.\n\nGreets,\nPaul Engel\n@archan937"
    alert.show

    count = alert.message.split("\n").collect(&:size).max + 2
    puts ["", "=" * count, "", alert.title, "", alert.message, "", "=" * count]

  end
end