class PageRangeHelper
  MAXIMUM_RANGE = 8
  LAST_POSITION = 7
  MIDDLE_POSITION = 4

  MINIMUM_THRESHOLD = 5 # signifies how close the active page has to be to the start before the tiles start scrolling
  MAXIMUM_THRESHOLD = 3 # signifies how close the active page has to be to the end before the tiles stop scrolling

  # Initialises a PageRangeHelper object which helps creating the pagination tiles at the bottom of a search page
  #
  # @param [PaginationHelper] pagination_helper an instance of PaginationHelper which provides page information
  def initialize(pagination_helper)
    @pagination_helper = pagination_helper
  end

  # We think of pagination as an array of positions
  # If there are at least 8 pages, the array has 8 zero-indexed elements as such:
  # [0 .. 7]
  # Otherwise, the array has as many elements as there are pages. For example, if there are 4 pages in total, the array would be:
  # [0 .. 3]
  #
  # The array is populated by first finding where in the array the current page lies
  # and then filling in the elements preceding and succeeding the current page
  #
  # Refer to the tests for this class to see this in action
  def page_range
    return @page_range if @page_range

    page_range = Array.new(page_range_length)

    page_range[active_tile_position] = pagination_helper.current_page

    (0...active_tile_position).each do |i|
      populate_element(page_range, i)
    end

    ((active_tile_position + 1)...page_range_length).each do |i|
      populate_element(page_range, i)
    end

    @page_range = page_range
  end

  # This method returns a value that is used in the zero-indexed pagination array
  def active_tile_position
    return @active_tile_position if @active_tile_position

    return @active_tile_position = last_page_position if pagination_helper.current_page > pagination_helper.total_pages

    return @active_tile_position = pagination_helper.previous_page if page_close_to_start? || total_pages_less_than_maximum?

    return @active_tile_position = LAST_POSITION - (pagination_helper.total_pages - pagination_helper.current_page) if page_close_to_end?

    @active_tile_position = MIDDLE_POSITION
  end

  def last_page
    page_range.last
  end

  private

  attr_reader :pagination_helper

  def populate_element(page_range, index)
    page_range[index] = pagination_helper.current_page + index - active_tile_position
  end

  def page_close_to_start?
    pagination_helper.current_page <= MINIMUM_THRESHOLD
  end

  def total_pages_less_than_maximum?
    pagination_helper.total_pages <= MAXIMUM_RANGE
  end

  def page_close_to_end?
    pagination_helper.current_page >= (pagination_helper.total_pages - MAXIMUM_THRESHOLD)
  end

  # The pagination array length is always 8, unless there are less than 8 pages in total
  def page_range_length
    [pagination_helper.total_pages, MAXIMUM_RANGE].min
  end

  def last_page_position
    [page_range_length, LAST_POSITION].min
  end
end
