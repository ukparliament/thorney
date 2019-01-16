require_relative '../rails_helper'

RSpec.describe CardFactory, type: :serializer do
  let(:subject) { described_class.new(small: 'some_small', heading_text: 'card__example', heading_url: 'example url', paragraph_content: [{ content: 'example paragraph' }]) }


  context '#build_card' do
    it 'receives the correct serializers' do
      allow(ComponentSerializer::CardComponentSerializer).to receive(:new)

      subject.build_card

      expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(name: 'card__generic', data: { small: {"data"=>{"content"=>"some_small"}, "name"=>"partials__small"}, heading: { "data"=> {"content"=>"<a href=\"example url\">card__example</a>", "size"=>2}, "name"=>"heading"}, paragraph: {"data"=>[{"content"=>"example paragraph"}], "name"=>"paragraph" } } )
    end

    context 'when given all data' do
      it 'produces the expected JSON hash' do

        expected = get_fixture('fixture')

        expect(subject.build_card.to_yaml).to eq expected
      end
    end

    context 'when given only a heading' do
      it 'produces the expected JSON hash' do
        serializer = described_class.new(heading_text: 'card__example', heading_url: 'example url')

        expected = get_fixture('heading_only')

        expect(serializer.build_card.to_yaml).to eq expected
      end
    end
  end
end
