require_relative '../../rails_helper'

RSpec.describe PageSerializer::ProcedureStepsShowPageSerializer, vcr: true do
  include_context "sample request", include_shared: true

  let(:response) {Parliament::Request::UrlRequest.new(base_url:   ENV['PARLIAMENT_BASE_URL'],
                                                      builder:    Parliament::Builder::NTripleResponseBuilder,
                                                      decorators: Parliament::Grom::Decorator).procedure_step_by_id.set_url_params({ procedure_step_id: 'e9G2vHbc' }).get}

  let(:procedure_step) {response.filter('https://id.parliament.uk/schema/ProcedureStep').first}

  subject { described_class.new(request: request, procedure_step: procedure_step) }

  describe '#to_h' do
    it 'produces the expected JSON hash' do
      expected = get_fixture('fixture')

      expect(subject.to_yaml).to eq expected
    end

    context 'when there is partial data for a house' do
      it 'produces the expected JSON hash' do
        expected = get_fixture('fixture_with_partial_house_data')

        expect(subject.to_yaml).to eq expected
      end
    end
  end
end
