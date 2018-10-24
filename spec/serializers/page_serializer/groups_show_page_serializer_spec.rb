require_relative '../../rails_helper'

RSpec.describe PageSerializer::GroupsShowPageSerializer, vcr: true do
  include_context "sample request", include_shared: true

  let(:response) { Parliament::Request::UrlRequest.new(
      base_url: ENV['PARLIAMENT_BASE_URL'],
      builder: Parliament::Builder::NTripleResponseBuilder,
      decorators: Parliament::Grom::Decorator).group_by_id.get }
  let(:group) { response.filter('https://id.parliament.uk/schema/Group').first }

  subject { described_class.new(request: request, group: group) }

  context '#to_h' do
    it 'produces the expected JSON hash' do

      expected = get_fixture('fixture')

      expect(subject.to_yaml).to eq expected
    end
  end

  context 'group not laying body' do
    it 'produces the expected JSON hash without layings' do

      expected = get_fixture('group_not_laying_body')

      expect(subject.to_yaml).to eq expected
    end
  end

  context 'with end date' do

    it 'produces the expected JSON hash with an end date' do

      expected = get_fixture('group_with_end_date')

      expect(subject.to_yaml).to eq expected
    end
  end

  context 'with no start or end date' do

    it 'produces the expected JSON hash with no start or end date' do

      expected = get_fixture('group_with_no_date')

      expect(subject.to_yaml).to eq expected
    end
  end

  context 'with no name' do

    it 'produces the expected JSON hash with no name' do

      expected = get_fixture('group_with_no_name')

      expect(subject.to_yaml).to eq expected
    end
  end

  context 'with no name or dates' do

    it 'produces the expected JSON hash with no name or dates' do

      expected = get_fixture('group_with_no_name_or_dates')

      expect(subject.to_yaml).to eq expected
    end
  end
end
