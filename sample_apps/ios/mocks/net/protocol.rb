module Net
  class ProtocolError < StandardError; end
  class ProtoAuthError < ProtocolError; end
  class Protocol
    def self.hi!
      "Hi, I'm #{name}"
    end
  end
end