require_relative '../../rails_helper'

RSpec.describe ListDescriptionHelper, type: :helper do
  describe '#create_description_list_item' do
    class Dummy
      include ListDescriptionHelper
    end

    let(:dummy_class) { Dummy.new }

    it 'produces the expected hash for a description list item' do
      expected_hash = {
        term:        {
          content: 'email'
        },
        description: [
                       {
                         content: 'hello@example.com'
                       },
                       {
                         content: 'hello@gmail.com'
                       }
                     ]
      }
      item = dummy_class.create_description_list_item('email', ['hello@example.com', 'hello@gmail.com'])

      expect(item).to eq(expected_hash)
    end

    it 'does not produce a hash for an empty description array' do
      item = dummy_class.create_description_list_item('email', [])

      expect(item).to be(nil)
    end

    it 'does not produce a hash for a description array with only nil content' do
      item = dummy_class.create_description_list_item('email', [nil, nil])

      expect(item).to be(nil)
    end

    it 'does not produce a hash for a description array with only empty string content' do
      item = dummy_class.create_description_list_item('email', ['', ''])

      expect(item).to be(nil)
    end
  end
end