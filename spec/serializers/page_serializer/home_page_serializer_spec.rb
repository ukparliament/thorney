require_relative '../../rails_helper'

RSpec.describe PageSerializer::HomePageSerializer, vcr: true do
  include_context "sample request", include_shared: true

  context '#to_h' do
    it 'produces a JSON hash' do

      expected = get_fixture('fixture')

      expect(subject.to_yaml).to eq expected
    end
  end
end
