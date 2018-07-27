require_relative '../../rails_helper'

RSpec.describe ComponentSerializer::BaseComponentSerializer do
  context '#to_h' do
    it 'raises an error if called in BaseComponentSerializer' do
      expect { subject.to_h }.to raise_error('You must implement #name')
    end
  end

  context '#data' do
    it 'raises an error if called in BaseComponentSerializer' do
      expect { subject.send(:data) }.to raise_error('You must implement #data')
    end
  end
end
