module ComponentSerializer
  class CountComponentSerializer < BaseComponentSerializer
    # Initialise a count partial.
    #
    # @param [String] count_number the number of things counted.
    # @param [String] count_context the things being counted.
    #
    # @example Initialising a count partial
    #  numer_of_items = 3
    #  things_being_counted = 'Mps'
    #  ComponentSerializer::CountComponentSerializer.new(count_number: number_of_items, count_context: things_being_counted).to_h
    def initialize(count_number: nil, count_context: nil)
      @count_number = count_number
      @count_context = count_context
    end

    def name
      'partials__count'
    end

    def data
      {}.tap do |hash|
        hash[:count_number] = @count_number if @count_number
        hash[:count_context] = @count_context if @count_context
      end
    end
  end
end
