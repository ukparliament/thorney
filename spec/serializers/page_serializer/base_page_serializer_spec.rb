require_relative '../../rails_helper'

describe PageSerializer::BasePageSerializer do
  let ( :base_page_serializer ) { described_class.new }

  context '#to_h' do
    it 'raises an error' do
      expect { base_page_serializer.to_h }.to raise_error('You must implement #title')
    end
  end

  context '#main_components' do
    it 'raises an error' do
      expect { base_page_serializer.send(:main_components) }.to raise_error('You must implement #content')
    end
  end
end
