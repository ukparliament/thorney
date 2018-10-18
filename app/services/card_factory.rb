class CardFactory
  def initialize(heading_text: nil, heading_url: nil, paragraph_content: nil, description_list_content: nil)
    @heading_text = heading_text
    @heading_url = heading_url
    @paragraph_content = paragraph_content
    @description_list_content = description_list_content
  end

  def build_card
    ComponentSerializer::CardComponentSerializer.new(name: 'card__generic', data: card_data).to_h
  end

  private

  def card_data
    {}.tap do |hash|
      hash[:heading] = card_heading if @heading_text
      hash[:paragraph] = card_paragraph if @paragraph_content
      hash[:list_description] = card_description_list if @description_list_content
    end
  end

  def card_heading
    ComponentSerializer::HeadingComponentSerializer.new(content: @heading_text, size: 2, link: @heading_url).to_h
  end

  def card_paragraph
    ComponentSerializer::ParagraphComponentSerializer.new(content: @paragraph_content).to_h
  end

  def card_description_list
    ComponentSerializer::ListDescriptionComponentSerializer.new(items: @description_list_content).to_h
  end
end
