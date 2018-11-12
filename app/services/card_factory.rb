class CardFactory
  def initialize(small: nil, heading_text: nil, heading_translation_url: nil, heading_url: nil, paragraph_content: nil, description_list_content: nil)
    @small = small
    @heading_text = heading_text
    @heading_translation_url = heading_translation_url
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
      hash[:small] = card_small if @small
      hash[:heading] = card_heading if @heading_text
      hash[:paragraph] = card_paragraph if @paragraph_content
      hash[:list_description] = card_description_list if @description_list_content
    end
  end

  def card_small
    ComponentSerializer::SmallComponentSerializer.new(content: @small).to_h
  end

  def card_heading
    return ComponentSerializer::HeadingComponentSerializer.new(content: ContentDataHelper.content_data(content: @heading_text, link: @heading_translation_url), size: 2).to_h if @heading_translation_url

    ComponentSerializer::HeadingComponentSerializer.new(content: @heading_text, size: 2, link: @heading_url).to_h
  end

  def card_paragraph
    ComponentSerializer::ParagraphComponentSerializer.new(content: @paragraph_content).to_h
  end

  def card_description_list
    ComponentSerializer::ListDescriptionComponentSerializer.new(items: @description_list_content).to_h
  end
end
