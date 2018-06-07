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

  def current_page
    @start_index / @count + 1
  end

  def first_page
    # Set first_page value to 1 when current_page is less-than or equal-to 6.
    return 1 if current_page <= 6

    # Stop page_range from scrolling when current_page is greater-than the last 4.
    if current_page > last_page - (10 - 6) && last_page > 10
      return last_page - (10 - 1)
    end

    # Set first_page to current_page minus 5.
    current_page - (6 - 1)
  end

  def last_page
    if @results_total.to_i < 10 * @count
      (@results_total.to_f / @count).ceil
    elsif current_page < 7
      10
    else
      current_page + 4 < (@results_total.to_f / @count).ceil ? current_page + 4 : (@results_total.to_f / @count).ceil
    end
  end

  def total_pages
    (@results_total.to_f / @count).ceil
  end

  def page_range
    (first_page...current_page).to_a.concat((current_page..last_page).to_a)
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

  def active_tile
    if current_page > (@count / 2) && current_page < @count - (@count / 2 - 1)
      6
    elsif current_page > @count - (@count / 2 - 1)
      @count - (last_page - current_page)
    else
      current_page
    end
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

  def navigation_section_components
    data = {}.tap do |hash|
      hash[:active_tile] = active_tile
      handle_previous_url(hash)
      handle_next_url(hash)
      hash[:components] = create_number_cards
    end

    [ComponentSerializer::CardComponentSerializer.new('navigation__number__number', data).to_h]
  end

  private

  def handle_previous_url(hash)
    hash.tap do |h|
      h[:previous_url] = previous_url unless current_page == 1
    end
  end

  def handle_next_url(hash)
    hash.tap do |h|
      h[:next_url] = next_url unless current_page == last_page
    end
  end

  def create_number_cards
    page_range.map do |page|
      data = {}.tap do |hash|
        hash[:url] = number_card_url(page)
        hash[:data_number] = page
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
