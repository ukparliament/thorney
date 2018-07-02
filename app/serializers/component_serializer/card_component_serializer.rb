module ComponentSerializer
  class CardComponentSerializer < ComponentSerializer::BaseComponentSerializer
    attr_reader :data

    # Initialise a card component.
    #
    # @param [String] card_type name of the card.
    # @param [String] data data of the card.
    def initialize(card_type, data)
      @card_type = card_type
      @data = data
    end

    private

    def name
      @card_type
    end
  end
end
