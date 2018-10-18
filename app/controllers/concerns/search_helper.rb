module SearchHelper
  # Sanitises the search term to prevent xss attacks
  #
  # @param [String] params query string to be sanitised
  # @return [String] a query string that has been sanitised
  # @example sanitising a string
  #   SearchHelper.sanitize_query('<script>alert(document.cookie)</script>') #=> ''
  def self.sanitize_query(params)
    Sanitize.fragment(params, Sanitize::Config::RELAXED)
  end
end
