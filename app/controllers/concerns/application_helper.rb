module ApplicationHelper
  # What MIME types does the API accept?
  #
  # Note: All of the below are used to generate MIME types that our application will answer to, but NOT the
  # alternatives shown in our header. See ALTERNATIVE_MIME_TYPE_CONFIG.
  API_MIME_TYPE_CONFIG = [
    {
      nt: 'application/n-triples'
    },
    {
      ttl: 'text/turtle'
    },
    {
      tsv: 'text/tab-separated-values'
    },
    {
      csv: 'text/csv'
    },
    {
      rj: 'application/json+rdf'
    },
    {
      jsonld: 'application/json+ld',
      json:   'application/json'
    },
    {
      rdfxml: 'application/rdf+xml',
      rdf:    'application/xml',
      xml:    'text/xml'
    }
  ].freeze

  # Use the above, minus the last two entries (json & xml), to build an alternative URL list.
  # Then re-create JSON and XML with the correct alternatives
  ALTERNATIVE_MIME_TYPE_CONFIG = API_MIME_TYPE_CONFIG.take(API_MIME_TYPE_CONFIG.size - 2).concat(
    [
      {
        json: 'application/json+ld'
      },
      {
        xml: 'application/rdf+xml'
      }
    ]
  )

  API_MIME_TYPES                   = ApplicationHelper::API_MIME_TYPE_CONFIG.map(&:values).flatten.freeze
  API_FILE_EXTENSIONS              = ApplicationHelper::API_MIME_TYPE_CONFIG.map(&:keys).flatten.freeze
  ALTERNATIVE_MIME_TYPES_FLATTENED = ApplicationHelper::ALTERNATIVE_MIME_TYPE_CONFIG.reduce(:merge)

  # Before every request that provides data, see if the user is requesting a format that can be served by the data API.
  # If they are, transparently redirect them with a '302: Found' status code
  def data_check
    # Check format to see if it is available from the data API
    # We DO NOT offer data formats for constituency maps
    return if !API_MIME_TYPES.include?(request.formats.first) || (params[:controller] == 'constituencies' && params[:action] == 'map')

    # Find the current controller/action's API url
    @data_url = data_url

    # Catch potential nil values
    raise StandardError, 'Data URL does not exist' if @data_url.nil?

    # Get the requested type
    response.headers['Accept'] = request.formats.first.to_s

    # Set redirect_url as URI object
    redirect_url = build_redirect_url

    redirect_to(redirect_url.to_s)
  end

  # Get the data URL for our current controller and action OR raise a StandardError
  #
  # @raises [StandardError] if there is no Proc available for a controller and action pair, we raise a StandardError
  #
  # @return [Proc] a Proc which can be called to generate a data URL
  def data_url
    self.class::ROUTE_MAP[params[:action].to_sym] || raise(StandardError, "You must provide a ROUTE_MAP proc for #{params[:controller]}##{params[:action]}")
  end

  # Populates @request with a data url which can be used within controllers.
  def build_request
    @request = data_url.call(params)

    populate_alternates(@request.query_url)
  end

  # Populates @alternates with a list of data formats and corresponding urls
  #
  # @param [String] url the url where alternatives can be found
  def populate_alternates(url)
    @alternates = []

    ALTERNATIVE_MIME_TYPES_FLATTENED.each do |extension, format| # (key, value)
      uri      = URI.parse(url)
      uri.path = "#{uri.path}.#{extension}"

      @alternates << { type: format, href: uri.to_s }
    end

    @alternates
  end

  private

  # Before every request, reset the list of alternates to prevent showing rel-alternate tags on pages without data
  def reset_alternates
    @alternates = []
  end

  def build_redirect_url
    redirect_url = URI(@data_url.call(params).query_url)

    # Get the request url as a URI object
    request_extension = File.extname(URI.parse(request.url).path)
    redirect_url.path = redirect_url.path + request_extension if request_extension != ''

    redirect_url
  end
end
