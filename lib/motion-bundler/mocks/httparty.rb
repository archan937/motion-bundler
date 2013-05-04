module HTTParty
  extend self

  def included(base)
    base.extend self
  end

  def format(f)
    @format = f
  end

  def base_uri(u)
    @base_uri = u.sub(/\/$/, "")
  end

  def basic_auth(user, password)
    @basic_auth = [user, password]
  end

  def get(path, options = {}, &block)
    send_request path, :get
  end

  def post(path, options = {}, &block)
    send_request path, :post
  end

  def put(path, options = {}, &block)
    send_request path, :put
  end

  def delete(path, options = {}, &block)
    send_request path, :delete
  end

private

  def send_request(path, method, options = {})
    path   = "#{@base_uri}/#{path}" if @base_uri && !path.match(/^\w+:\/\//)
    path   = path.stringByAddingPercentEscapesUsingEncoding NSUTF8StringEncoding
    method = method.to_s.upcase

    if options[:body]
      payload = payload_to_query_string(options[:body]).dataUsingEncoding(NSUTF8StringEncoding) if POST / PUT && payload
    end

    if payload && method == "GET"
      path << "#{path.include?("?") ? "&" : "?"}#{payload}"
    end

    url = NSURL.URLWithString path.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    request = NSMutableURLRequest.requestWithURL url

    if @basic_auth
      auth_header = "Basic " + [@basic_auth.join(":")].pack("m0").dataUsingEncoding(NSUTF8StringEncoding)
      request.addValue auth_header, forHTTPHeaderField: "Authorization"
      request.HTTPMethod = method
    end

    if payload
      request.HTTPBody = payload
    end

    response = Pointer.new :object
    error    = Pointer.new :object
    data     = NSURLConnection.sendSynchronousRequest request, returningResponse: response, error: error

    HTTParty::Response.new response, data, {:format => @format, :error => error}
  end

  def payload_to_query_string(payload_hash)
    payload_hash_to_array(payload_hash).collect{|key, value| "#{escape key}=#{escape value}"}.join "&"
  end

  def payload_hash_to_array(hash, prefix = nil)
    array = []
    hash.each do |key, value|
      if value.is_a?(Hash)
        array += payload_hash_to_array(value, prefix ? "#{prefix}[#{key.to_s}]" : key.to_s)
      elsif value.is_a?(Array)
        value.each do |val|
          array << [prefix ? "#{prefix}[#{key.to_s}][]" : "#{key.to_s}[]", val]
        end
      else
        array << [prefix ? "#{prefix}[#{key.to_s}]" : key.to_s, value]
      end
    end
    array
  end

  def escape(string)
    CFURLCreateStringByAddingPercentEscapes(nil, string, "[]", ";=&,", KCFStringEncodingUTF8) if string
  end

end

module HTTParty
  class Response

    def initialize(response, data, options = {})
      @cached_response = NSCachedURLResponse.alloc.initWithResponse response.value, data: data
      @options = options
    end

    def parsed_response
      @parsed_response ||= begin
        case @options[:format]
        when :json
          NSJSONSerialization.JSONObjectWithData @cached_response.data, options: NSJSONReadingMutableContainers, error: nil
        else
          NSString.alloc.initWithData @cached_response.data, encoding: NSUTF8StringEncoding
        end
      end
    end

    def code
      @cached_response.response.statusCode
    end

    def ok?
      code.to_s.match /^20\d$/
    end

  end
end