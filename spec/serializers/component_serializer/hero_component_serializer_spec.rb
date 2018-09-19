require_relative '../../rails_helper'

RSpec.describe ComponentSerializer::HeroComponentSerializer do
  let ( :components ) { [1, 2] }

  context '#to_h' do
    context 'a hero' do
      it 'if content_flag is true' do
        serializer = described_class.new(components: components, content_flag: true)

        expected = get_fixture('fixture')

        expect(serializer.to_yaml).to eq expected
      end

      it 'if content_flag is not provided' do
        serializer = described_class.new(components: components)

        expected = get_fixture('no_content_flag')

        expect(serializer.to_yaml).to eq expected
      end
    end

  end
end
