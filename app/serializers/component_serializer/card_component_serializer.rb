module ComponentSerializer
  class CardComponentSerializer < ComponentSerializer::BaseComponentSerializer
    # Initialise a card component.
    #
    # @param [String] name name of the card.
    # @param [Hash] data data of the card.
    #
    # @example Initialising a card component
    #  card_file_name = 'card__generic'
    #  pugin_card_type = 'small'
    #  card_heading = ComponentSerializer::HeadingComponentSerializer.new(content: 'Card Heading', size: 3, link: 'beta.parliament.uk').to_h
    #  card_paragraph = ComponentSerializer::ParagraphComponentSerializer.new(content: [{ content: 'Card paragraph' }]).to_h
    #  card_list_description = ComponentSerializer::ListDescriptionComponentSerializer.new(items: [{ 'term': { 'content': 'Phone number' }, 'description': [{ 'content': '000010001' }] }, { 'term': { 'content': 'Email' }, 'description': [{ 'content': 'example@email.provider.com' }] }]).to_h
    #  card_list_generic = ComponentSerializer::ListComponentSerializer.new(display: 'generic', display_data: [display_data(component: 'list', variant: 'block')], type: 'ol', contents: ['Interesting example 1', 'interesting example 2']).to_h
    #  card_figure = ComponentSerializer::FigureComponentSerializer.new(display_data: [display_data(component: 'avitar', variant: 'round')], link: 'beta.parliament.uk', aria_hidden: true, tab_index: true, img: { alt_text: 'Dianne Abbott', source: 'https://api.parliament.uk/photo/S3bGSTqn.jpeg?crop=CU_1:1&amp;amp;width=260&amp;amp;quality=80' }).to_h
    #  card_link_button = ComponentSerializer::FigureComponentSerializer.new('See figure for arguments').to_h
    #  card_count =  ComponentSerializer::CountComponentSerializer.new(count_number: 2, count_context: 'Mps').to_h
    #  ComponentSerializer::CardComponentSerializer.new(name: card_file_name, data: {card_type: pugin_card_type, heading: card_heading, paragraph: card_paragraph, list_description: card_list_description, list_generic: card_list_generic, figure: card_figure, link_button: card_link_button, count: card_count}).to_h
    def initialize(name: nil, data: nil)
      @name = name
      @data = data
    end

    private

    attr_reader :name, :data
  end
end
