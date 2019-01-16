require_relative '../../rails_helper'

RSpec.describe ParliamentHelper do
  context '.parliament_request' do
    it 'returns a Parliament::Request::UrlRequest object' do
      expect(described_class.parliament_request.class).to eq(Parliament::Request::UrlRequest)
    end

    context 'returned Parliament::Request::UrlRequest object' do
      before :each do
        stub_const('::ENV', { "PARLIAMENT_API_VERSION" => 'Live' })
      end

      let(:parliament_request){ described_class.parliament_request }

      it 'will have correct builder' do
        expect(parliament_request.instance_variable_get(:@builder)).to eq(Parliament::Builder::NTripleResponseBuilder)
      end

      it 'will have correct headers' do
        expect(parliament_request.instance_variable_get(:@headers).keys.count).to eq(2)
        expect(parliament_request.instance_variable_get(:@headers).keys).to eq(['Ocp-Apim-Subscription-Key', 'Api-Version'])
      end

      it 'will have correct decorator' do
        expect(parliament_request.instance_variable_get(:@decorators)).to eq(Parliament::Grom::Decorator)
      end
    end
  end

  context '#parliament_request' do
    let(:dummy_class){ Class.new { include ParliamentHelper } }
    let(:instance){ dummy_class.new }

    it 'will call Parliament::Utils::Helpers::ParliamentHelper.parliament_request' do
      expect(instance.parliament_request.class).to eq(Parliament::Request::UrlRequest)
    end
  end
end