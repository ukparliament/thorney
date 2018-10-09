require_relative '../../rails_helper'

RSpec.describe ComponentSerializer::CardComponentSerializer do
  context '#to_h' do
    it 'returns a hash containing name and all possible data' do
      serializer = described_class.new(
        name:'some_card',
        data: {card_type: 'pugin_card_type',
        heading: 'card_heading',
        paragraph: 'card_paragraph',
        list_description: 'card_list_description',
        list_generic: 'card_list_generic',
        figure: 'card_figure',
        link_button: 'card_link_button',
        count: 'card_count'})

      expected = get_fixture('fixture')

      expect(serializer.to_yaml).to eq expected
    end

  end
end
