require_relative '../../rails_helper'

RSpec.describe ComponentSerializer::ListDescriptionComponentSerializer do
  context '#to_h' do
    context 'with items provided' do
      it 'returns a hash containing the name and data' do
        serializer = described_class.new(
          items:
            [{
               "term":
                   {
                     "content": "telephone"
                   },
               "description":
                 [
                   {
                     "content": "012349586"
                   }
                 ]
             },
             {
               "term":
                   {
                     "content": "website"
                   },
               "description":
                 [
                   {
                     "content": "<a href='www.example.com'>My home page</a>"
                   }
                 ]
             },
             {
               "term":
                   {
                     "content": "email"
                   },
               "description":
                 [
                   {
                     "content": "hello@example.com"
                   },
                   {
                     "content": "hello@gmail.com"
                   }
                 ]
             }
            ])

        expected = get_fixture('description')

        expect(serializer.to_yaml).to eq expected
      end

      it 'when time tags are passed in to the description' do
        serializer = described_class.new(
          "items":
            [{
               "term":
                   {
                     "content": "Date"
                   },
               "description":
                 [
                   TimeHelper.time_translation(date_first: DateTime.parse('23/12/2016'), date_second: DateTime.parse('23/12/2017'))
                 ]
             }
            ])

        expected   = get_fixture('time_helper')

        expect(serializer.to_yaml).to eq expected
      end
    end

    context 'with meta set to true' do
      it 'returns a hash containing name and data as expected' do
        serializer = described_class.new(meta: true)

        expected = get_fixture('meta')

        expect(serializer.to_yaml).to eq expected
      end

      it 'when items meta specified' do
        serializer = described_class.new(
          "meta": true,
          "items":
            [{
               "term":
                   {
                     "content": "telephone"
                   },
               "description":
                 [
                   {
                     "content": "012349586"
                   }
                 ]
             },
             {
               "term":
                   {
                     "content": "website"
                   },
               "description":
                 [
                   {
                     "content": "<a href='www.example.com'>My home page</a>"
                   }
                 ]
             },
             {
               "term":
                   {
                     "content": "email"
                   },
               "description":
                 [
                   {
                     "content": "hello@example.com"
                   },
                   {
                     "content": "hello@gmail.com"
                   }
                 ]
             }
            ])

        expected   = get_fixture('description_meta')

        expect(serializer.to_yaml).to eq expected
      end

    end
  end
end
