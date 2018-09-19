module FilterHelper
  # Takes a request object and a variable amount of types for filtering, gets types_to_filter using #filter_types method, and calls RequestHelper.filter_response_data to return filtered NTriple Object
  #
  # @param [Parliament::Request] request a Parliament::Request object
  # @param [String] types a variable amount of types to filter by
  #
  # @return [Parliament::Response::NTripleResponse] Ntriple response filtered by types
  def self.filter(request, *types)
    types_to_filter = filter_types(*types)
    RequestHelper.filter_response_data(
      request, *types_to_filter
    )
  end

  # Takes variable amount of types for filtering, checks if type is 'ordnance', and returns array of types to filter
  #
  # @param [String] types a variable amount of types to filter by
  #
  # @return [Array] array of types to filter by
  def self.filter_types(*types)
    types_to_filter = []

    types.each do |type|
      types_to_filter << if type == ::Grom::Node::BLANK
                           ::Grom::Node::BLANK
                         else
                           type == 'ordnance' ? 'http://data.ordnancesurvey.co.uk/ontology/admingeo/EuropeanRegion' : RequestHelper.namespace_uri_schema_path(type)
                         end
    end
    types_to_filter
  end

  # Takes a request, sort type, type to sort and letters to sort by.
  # Calls the #filter method to define type and letters
  # Sorts type by sort type
  # Maps letters using #value
  # Returns type and letters
  # @param [Parliament::Request] request a Parliament::Request object
  # @param [Symbol] sort_type how to sort type
  # @param [String] type the type to filter
  # @param [Grom::Node] letters Grom::Node to filter type by letters
  #
  # @return [Parliament::Response::NTripleResponse] Ntriple response filtered by letters
  def self.filter_sort(request, sort_type, type, letters)
    type, letters = filter(request, type, letters)
    type          = type.sort_by(sort_type)
    letters       = letters.map(&:value)
    [type, letters]
  end
end
