class PaginationHelper
  # Initialises a PaginationHelper object which helps with pagination and navigation on the search page
  #
  # @param [Hash] pagination_hash a hash that contains all the data needed for pagination and navigation
  # @param [PageRangeHelper] page_range_helper an instance of PageRangeHelper which provides an array for creating pagination tiles
  def initialize(pagination_hash, page_range_helper = PageRangeHelper)
    @start_index = pagination_hash[:start_index]
    @count = pagination_hash[:count]
    @results_total = pagination_hash[:results_total]
    @search_path = pagination_hash[:search_path]
    @query = pagination_hash[:query]

    @page_range_helper = page_range_helper.new(self)
  end

  def navigation_section_components
    data = {}.tap do |hash|
      hash[:active_tile] = page_range_helper.active_tile_position + 1
      hash[:previous_url] = previous_url unless current_page == 1
      hash[:next_url] = next_url unless current_page == page_range_helper.last_page
      hash[:components] = create_number_cards
    end

    [ComponentSerializer::CardComponentSerializer.new('navigation__number__number', data).to_h]
  end

  def current_page
    @current_page ||= (@start_index / @count + 1)
  end

  def total_pages
    @total_pages ||= (@results_total.to_f / @count).ceil
  end

  def previous_page
    current_page - 1
  end

  private

  attr_reader :page_range_helper

  def next_page
    current_page + 1
  end

  # Generate a start index for a given page number
  def start_index(page)
    (page - 1) * @count + 1
  end

  def number_card_url(page)
    create_page_url(start_index(page))
  end

  def previous_url
    create_page_url(start_index(previous_page))
  end

  def next_url
    create_page_url(start_index(next_page))
  end

  def create_number_cards
    page_range_helper.page_range.map do |page|
      data = {}.tap do |hash|
        hash[:url] = number_card_url(page)
        hash[:number] = page
        hash[:total_count] = "of #{total_pages}"
        hash[:active] = true if page == current_page
      end

      ComponentSerializer::CardComponentSerializer.new('navigation__number__card', data).to_h
    end
  end

  def create_page_url(start_index)
    "#{@search_path}?count=#{@count}&q=#{@query}&start_index=#{start_index}"
  end
end
