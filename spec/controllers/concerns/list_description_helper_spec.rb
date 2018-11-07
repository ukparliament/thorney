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
      item = dummy_class.create_description_list_item(term: 'email', descriptions: ['hello@example.com', 'hello@gmail.com'])

      expect(item).to eq(expected_hash)
    end

    it 'produces the expected hash when term and description items have translation keys and data' do
      expected_hash = {
        term:        {
          content: 'translation key',
          data: { first_bit_of_data: "Data 1", second_bit_of_data: "Data 2" }
        },
        description: [
                       {
                         content: 'translation key 2',
                         data: { first_bit_of_data: "Data 3", second_bit_of_data: "Data 4" }
                       },
                       {
                         content: 'translation key 3',
                         data: { first_bit_of_data: "Data 5", second_bit_of_data: "Data 6" }
                       }
                     ]
      }
      item = dummy_class.create_description_list_item(
        term: ContentDataHelper.content_data(content: 'translation key', first_bit_of_data: "Data 1", second_bit_of_data: "Data 2"),
        descriptions: [
          ContentDataHelper.content_data(content: 'translation key 2', first_bit_of_data: "Data 3", second_bit_of_data: "Data 4"),
          ContentDataHelper.content_data(content: 'translation key 3', first_bit_of_data: "Data 5", second_bit_of_data: "Data 6")
        ]
      )

      expect(item).to eq(expected_hash)
    end

    it 'produces the expected hash when term and description items have translation keys and data' do
      expected_hash = {
        term:        {
          content: 'translation key',
          data: { first_bit_of_data: "Data 1", second_bit_of_data: "Data 2" }
        },
        description: [
                       {
                         content: 'hello@example.com'
                       },
                       {
                         content: 'translation key 3',
                         data: { first_bit_of_data: "Data 5", second_bit_of_data: "Data 6" }
                       }
                     ]
      }
      item = dummy_class.create_description_list_item(
        term: ContentDataHelper.content_data(content: 'translation key', first_bit_of_data: "Data 1", second_bit_of_data: "Data 2"),
        descriptions: [
          'hello@example.com',
          ContentDataHelper.content_data(content: 'translation key 3', first_bit_of_data: "Data 5", second_bit_of_data: "Data 6")
        ]
      )

      expect(item).to eq(expected_hash)
    end


    it 'does not produce a hash for an empty description array' do
      item = dummy_class.create_description_list_item(term: 'email', descriptions: [])

      expect(item).to be(nil)
    end

    it 'does not produce a hash for a description array with only nil content' do
      item = dummy_class.create_description_list_item(term: 'email', descriptions: [nil, nil])

      expect(item).to be(nil)
    end

    it 'does not produce a hash for a description array with only empty string content' do
      item = dummy_class.create_description_list_item(term: 'email', descriptions: ['', ''])

      expect(item).to be(nil)
    end
  end
end
