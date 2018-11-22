require_relative '../rails_helper'

RSpec.describe LaidThingListComponentsFactory, type: :serializer, vcr: true do
  let(:si_response) { Parliament::Request::UrlRequest.new(base_url:   ENV['PARLIAMENT_BASE_URL'],
                                                      builder:    Parliament::Builder::NTripleResponseBuilder,
                                                      decorators: Parliament::Grom::Decorator).statutory_instrument_index.get }

  let(:pnsi_response) { Parliament::Request::UrlRequest.new(base_url:   ENV['PARLIAMENT_BASE_URL'],
                                                         builder:    Parliament::Builder::NTripleResponseBuilder,
                                                         decorators: Parliament::Grom::Decorator).proposed_negative_statutory_instrument_index.get }

  let(:laid_paper_response) { Parliament::Request::UrlRequest.new(base_url:   ENV['PARLIAMENT_BASE_URL'],
                                                              builder:    Parliament::Builder::NTripleResponseBuilder,
                                                              decorators: Parliament::Grom::Decorator).group_laid_papers_index.get }

  let(:statutory_instruments) { si_response.filter('https://id.parliament.uk/schema/StatutoryInstrumentPaper') }
  let(:proposed_negative_statutory_instruments) { pnsi_response.filter('https://id.parliament.uk/schema/ProposedNegativeStatutoryInstrumentPaper') }
  let(:laid_papers) { laid_paper_response.filter('https://id.parliament.uk/schema/LaidThing') }

  context '#build_components' do
    context 'statutory_instruments' do
      it 'gives the correct data to the serializer' do
        allow(ComponentSerializer::CardComponentSerializer).to receive(:new)

        described_class.build_components(statutory_instruments: statutory_instruments)

        expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(name: 'card__generic', data: { heading: { "data"=> { "content"=> "<a href=\"/statutory-instruments/5trFJNih\">laidThingName - 1</a>", "size"=>2 }, "name"=>"heading"}, list_description: {"data"=>{"items"=>[{"description"=>[{"content"=>"shared.time-html","data"=>{"date"=>"23 April 2018", "datetime-value"=>"2018-04-23"}}],"term"=>{"content"=>"laid-thing.laid-date"}},{"description"=>[{"content"=>"groupName - 1"}],"term"=>{"content"=>"laid-thing.laying-body"}},{"description"=>[{"content"=>"procedureName - 1"}],"term"=>{"content"=>"laid-thing.procedure"}}]}, "name"=>"list__description" } } )
      end
    end

    context 'proposed_negative_statutory_instruments' do
      it 'gives the correct data to the serializer' do
        allow(ComponentSerializer::CardComponentSerializer).to receive(:new)

        described_class.build_components(statutory_instruments: proposed_negative_statutory_instruments)

        expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(
          name: 'card__generic',
          data: {
            heading: { "data"=> { "content"=> "<a href=\"/proposed-negative-statutory-instruments/Tn1xqHc0\">laidThingName - 1</a>", "size"=>2 }, "name"=>"heading"},
            list_description: {"data"=>{"items"=>[{"description"=>[{"content"=>"shared.time-html","data"=>{"date"=>"19 July 2018", "datetime-value"=>"2018-07-19"}}],"term"=>{"content"=>"laid-thing.laid-date"}},{"description"=>[{"content"=>"groupName - 10"}],"term"=>{"content"=>"laid-thing.laying-body"}},{"description"=>[{"content"=>"procedureName - 1"}],"term"=>{"content"=>"laid-thing.procedure"}}]}, "name"=>"list__description" }
            }
          )
      end
    end

    context 'laid_paper' do
      it 'gives the correct data to the serializer' do
        allow(ComponentSerializer::CardComponentSerializer).to receive(:new)
        described_class.build_components(statutory_instruments: laid_papers, small: true)

        expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(
          name: 'card__generic',
          data: {
            heading: {"data"=>{"content"=>"<a href=\"/statutory-instruments/keUmDe6y\">laidThingName - 1</a>","size"=>2},"name"=>"heading"},
            list_description: {"data"=>{"items"=>[{"description"=>[{"content"=>"shared.time-html","data"=>{"date"=>"27 April 2018", "datetime-value"=>"2018-04-27"}}],"term"=>{"content"=>"laid-thing.laid-date"}}, {"description"=>[{"content"=>"procedureName - 1"}],"term"=>{"content"=>"laid-thing.procedure"}}]}, "name"=>"list__description" },
            small: { "data"=>{"content"=>"Statutory instrument"}, "name"=>"partials__small" }
            }
          )
      end
    end
  end
end
