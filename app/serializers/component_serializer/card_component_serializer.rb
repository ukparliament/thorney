module ComponentSerializer
  class CardComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a card component.
    #
    # @param [String] name name of the card.
    # @param [String] data data of the card.
    def initialize(name, data)
      @name = name
      @data = data
    end

    private

    attr_reader :name, :data
  end
end
