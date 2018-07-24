class SearchController < ApplicationController
  def index
    # Show the index page if there is no query or an empty string is passed
    return render_page(PageSerializer::SearchPage::LandingPageSerializer.new(flash_message: search_service.flash_message, request_id: app_insights_request_id)) unless search_service.sanitised_query.present?

    search_service.fetch_description

    begin
      serialiser = PageSerializer::SearchPage::ResultsPageSerializer.new(query: search_service.sanitised_query, results: search_service.results, pagination_hash: search_service.pagination_hash, request_id: app_insights_request_id)

      return render_page(serialiser)
    rescue Parliament::ServerError => e
      logger.warn "Server error caught from search request: #{e.message}"
      serialiser = PageSerializer::SearchPage::ResultsPageSerializer.new(query: search_service.sanitised_query, request_id: app_insights_request_id)

      return render_page(serialiser)
    end
  end

  def opensearch
    description_file = <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <OpenSearchDescription xmlns="http://a9.com/-/spec/opensearch/1.1/">
        <ShortName>#{I18n.t('search_controller.opensearch.short_name')}</ShortName>
        <Description>Search #{I18n.t('search_controller.opensearch.short_name')} online content</Description>
        <Image height="16" width="16" type="image/x-icon">#{root_url}favicon.ico</Image>
        <Url type="text/html" template="#{search_url}?q={searchTerms}&amp;start_index={startIndex?}&amp;count={count?}" />
      </OpenSearchDescription>
    XML

    render xml: description_file, content_type: 'application/opensearchdescription+xml', layout: false
  end

  private

  def search_service
    @search_service ||= SearchService.new(@app_insights_request_id, search_url, params)
  end
end
