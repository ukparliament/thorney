class PaginationHelper
  # Initialises a PaginationHelper object which helps with pagination and navigation on the search page
  #
  # @param [Hash] pagination_hash a hash that contains all the data needed for pagination and navigation
  def initialize(pagination_hash)
    @start_index = pagination_hash[:start_index]
    @count = pagination_hash[:count]
    @results_total = pagination_hash[:results_total]
    @search_url = pagination_hash[:search_url]
    @query = pagination_hash[:query]
  end

  def navigation_section_components
    data = {}.tap do |hash|
      hash[:active_tile] = current_page
      hash[:previous_url] = previous_url unless current_page == 1
      hash[:next_url] = next_url unless current_page == last_page
      hash[:components] = create_number_cards
    end

    [ComponentSerializer::CardComponentSerializer.new('navigation__number__number', data).to_h]
  end

  private

  def current_page
    @start_index / @count + 1
  end

  def first_page
    # 1 when the current page is at most 6 pages from the first page OR there are at most 10 pages in total
    return 1 if (current_page <= 6) || (total_pages <= 10)

    # 9 less than the total number of pages if the current page has at most 4 pages until the last page
    return total_pages - 9 if current_page >= total_pages - 4

    # Otherwise the first page is 5 less than the current page
    current_page - 5
  end

  def last_page
    # The total number of pages if the current page has at most 4 pages until the last page OR there are at most 10 pages in total
    return total_pages if (current_page >= total_pages - 4) || (total_pages <= 10)

    # 10 if the current page is at most 6 pages from the first page
    return 10 if current_page <= 6

    # Otherwise the last page is 4 more than the current page
    current_page + 4
  end

  def total_pages
    (@results_total.to_f / @count).ceil
  end

  def page_range
    (first_page..last_page)
  end

  def next_page
    current_page + 1
  end

  def previous_page
    current_page - 1
  end

  # Generate a start index for a given page number
  def start_index(page)
    (page - 1) * @count + 1
  end

  def number_card_url(page)
    create_page_url(@count, start_index(page))
  end

  def previous_url
    create_page_url(@count, start_index(previous_page))
  end

  def next_url
    create_page_url(@count, start_index(next_page))
  end

  def create_number_cards
    page_range.map do |page|
      data = {}.tap do |hash|
        hash[:url] = number_card_url(page)
        hash[:number] = page
        hash[:total_count] = "of #{total_pages}"
        hash[:active] = true if page == current_page
      end

      ComponentSerializer::CardComponentSerializer.new('navigation__number__card', data).to_h
    end
  end

  def create_page_url(count, start_index)
    "#{@search_url}?count=#{count}&q=#{@query}&start_index=#{start_index}"
  end
end
