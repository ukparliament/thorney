require_relative '../../rails_helper'

RSpec.describe OpenGraphHelper do
  let(:subject) { OpenGraphHelper }

  describe '#information' do
    it 'generates the expected hash with no image id' do
      expected_hash = {
        title:        'My title',
        original_url: 'http://example.com',
        image_url:    'https://static.parliament.uk/assets-public/opengraph-oblong.png',
        image_width:  '1200',
        image_height: '630',
        twitter_card: 'summary_large_image'
      }

      expect(subject.information(page_title: 'My title', request_original_url: 'http://example.com')).to eq(expected_hash)
    end

    it 'generates the expected hash with an image id' do
      expected_hash = {
        title:        'My title',
        original_url: 'http://example.com',
        image_url:    'https://api.parliament.uk/photo/12345678.jpeg?crop=CU_1:1&width=400&quality=100',
        image_width:  '400',
        image_height: '400',
        twitter_card: 'summary'
      }

      expect(subject.information(page_title: 'My title', request_original_url: 'http://example.com', image_id: '12345678')).to eq(expected_hash)
    end
  end
end