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
      hash[:active_tile] = active_tile_position + 1
      hash[:previous_url] = previous_url unless current_page == 1
      hash[:next_url] = next_url unless current_page == page_range.last
      hash[:components] = create_number_cards
    end

    [ComponentSerializer::CardComponentSerializer.new('navigation__number__number', data).to_h]
  end

  private

  def current_page
    @start_index / @count + 1
  end

  def total_pages
    (@results_total.to_f / @count).ceil
  end

  # We think of pagination as an array of positions
  # If there are at least 10 pages, the array has 10 zero-indexed elements as such:
  # [0 .. 9]
  # Otherwise, the array has as many elements as there are pages. For example, if there are 7 pages in total, the array would be:
  # [0 .. 6]
  #
  # The array is populated by first finding where in the array the current page lies
  # and then filling in the elements preceding and succeeding the current page
  #
  # There are 4 possible cases for deciding where in the array the current page lies
  # 1. There are 10 or less pages in total:
  #   The position of current page in the array is one less than itself due to zero index
  #   For eg. The array for page 6 when there are 7 pages in total is [1, 2, 3, 4, 5, 6, 7]
  #
  # 2. The current page is at most 4 pages from the FIRST page
  #   The position of the current page in the array is one less than itself due to zero index
  #   For eg. The array for page 3 when there are 55 pages in total is [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  #
  # 3. The current page is at most 4 pages from the LAST page
  #   The position of the current page in the array is the difference between the total pages and current page subtracted from 9
  #   For eg. The array for page 53 when there are 55 pages in total is [46, 47, 48, 49, 50, 51, 52, 53, 54, 55]
  #
  # 4. The current page is somewhere in the middle
  #   The position of the current page in the array is 5, zero-indexed
  #   For eg. The array for page 32 when there are 55 pages in total is [27, 28, 29, 30, 31, 32, 33, 34, 35, 36]
  def page_range
    page_range = Array.new(page_range_length)

    page_range[active_tile_position] = current_page

    (0...active_tile_position).each do |i|
      page_range[i] = current_page + i - active_tile_position
    end

    ((active_tile_position + 1)...page_range.length).each do |i|
      page_range[i] = current_page + i - active_tile_position
    end

    page_range
  end

  # The pagination array length is always 10, unless there are less than 10 pages in total
  def page_range_length
    return total_pages if total_pages < 10

    10
  end

  # This method returns a value that is used in the zero-indexed pagination array
  def active_tile_position
    return current_page - 1 if current_page <= 5 || total_pages <= 10

    return 9 - (total_pages - current_page) if current_page >= total_pages - 4

    5
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
    create_page_url(start_index(page))
  end

  def previous_url
    create_page_url(start_index(previous_page))
  end

  def next_url
    create_page_url(start_index(next_page))
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

  def create_page_url(start_index)
    "#{@search_url}?count=#{@count}&q=#{@query}&start_index=#{start_index}"
  end
end
