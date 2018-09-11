module RequestHelper
  # The base namespace used for filtering parliamentary data within sparql queries
  NAMESPACE_URI = 'https://id.parliament.uk'.freeze

  # Takes a Parliament::Request and calls the #get method.
  # Then maps the #value method on the resulting response.
  #
  # @param [Parliament::Request] request a built Parliament::Request object that can just be called with #get
  #
  # @return [Array<String>]
  def self.process_available_letters(request)
    response = request.get
    response.map(&:value)
  end

  # Takes a Parliament::Request and a optional amount of filters and calls the #get method on on the request.
  # Then calls Parliament::Response#filter with the filters as the parameters on the resulting response.
  #
  # @param [Parliament::Request] request a built Parliament::Request object that can just be called with #get
  #
  # @return [Parliament::Response]
  def self.filter_response_data(request, *filters)
    request.get.filter(*filters)
  end

  # Returns the base namespace used for filtering parliamentary data within sparql queries
  #
  # @return [String]
  def self.namespace_uri
    NAMESPACE_URI
  end

  # Returns uri with specific path added for filtering parliamentary data within sparql queries
  #
  # @param [String] Path string to append to the base uri
  #
  # @return [String] uri with specific path added for filtering parliamentary data within sparql queries
  def self.namespace_uri_path(path)
    namespace_uri + path
  end

  # Returns uri with schema path and specific type added for filtering parliamentary data within sparql queries
  #
  # @param [String] Type string to append to the schema uri
  #
  # @return [String] uri with schema path and specific type added for filtering parliamentary data within sparql queries
  def self.namespace_uri_schema_path(type)
    namespace_uri_path("/schema/#{type}")
  end
end
