require_relative '../../rails_helper'

RSpec.describe ComponentSerializer::ListDescriptionComponentSerializer do
  context '#to_h' do
    context 'returns a hash containing the name and data' do
      it 'when items is specified' do
        serializer = described_class.new(
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

        expected   = get_fixture('description')

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
