module TimeHelper
  # Extracts and organises the dates of an item which can respond to start_date and end_date into a structure which a description list serializer can use as content.
  #
  # @param [Integer] :date_first the first or only date, if there is no end date, to go into the time tags.
  # @param [Integer] :date_second the second, normally the end date, to go into the time tags.
  # @param [Boolean] :to_present indicates if the date runs to the present.
  #
  # @return [Hash] a hash arranged to be used in a component as content whose conents will also be passed through the time tags key in the front end locals file.
  def self.time_translation(date_first: nil, date_second: nil, to_present: nil)
    {}.tap do |hash|
      hash[:content] = content_format(date_first: date_first, date_second: date_second, to_present: to_present)
      hash[:data] = date_format(date_first: date_first, date_second: date_second)
    end
  end

  def self.content_format(date_first: nil, date_second: nil, to_present: false)
    if date_first && to_present
      'shared.time-html-to-present'
    elsif date_first && date_second
      'shared.time-html-to'
    elsif date_first && !date_second
      'shared.time-html'
    end
  end

  def self.date_format(date_first: nil, date_second: nil)
    {}.tap do |hash|
      hash[:date] = I18n.l(date_first) if date_first
      hash[:datetime_value] = I18n.l(date_first, format: :datetime_format) if date_first
      hash[:date_second] = I18n.l(date_second) if date_second
      hash[:datetime_value_second] = I18n.l(date_second, format: :datetime_format) if date_second
    end
  end
end
