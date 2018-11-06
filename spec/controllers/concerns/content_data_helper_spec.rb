require_relative '../../rails_helper'

RSpec.describe ContentDataHelper, type: :helper do
  describe '#content_data' do

    it 'produces the expected hash with content and data' do
      expected_hash = {
        content: "translation key",
        data: {
          first_bit_of_data: "Data 1",
          second_bit_of_data: "Data 2"
        }
      }
      item = ContentDataHelper.content_data(content: 'translation key', first_bit_of_data: "Data 1", second_bit_of_data: "Data 2")

      expect(item).to eq(expected_hash)
    end

    it 'produces the expected hash with content' do
      expected_hash = { content: "translation key" }

      item = ContentDataHelper.content_data(content: 'translation key')

      expect(item).to eq(expected_hash)
    end
  end
end
