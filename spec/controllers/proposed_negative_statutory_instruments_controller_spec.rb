require 'rails_helper'

RSpec.describe ProposedNegativeStatutoryInstrumentsController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_index.nt",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_index.ttl",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_index.tsv",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_index.csv",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_index.rj",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_index.json",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_index.xml",
         :type => "application/rdf+xml" }]
    end

    let(:heading) { 'a heading component' }

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new).with(heading: 'Proposed negative statutory instruments') { heading }

      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @proposed_negative_statutory_instruments' do
      assigns(:proposed_negative_statutory_instruments).each do |statutory_instrument|
        expect(statutory_instrument).to be_a(Grom::Node)
        expect(statutory_instrument.type).to include('https://id.parliament.uk/schema/ProposedNegativeStatutoryInstrumentPaper')
      end
    end

    it 'calls the serializer correctly' do
      list_components = [{"data"=> {"heading"=> {"data"=> {"content"=>"<a href=\"/proposed-negative-statutory-instruments/Tn1xqHc0\">laidThingName - 1</a>", "size"=>2}, "name"=>"heading"}, "list-description"=> {"data"=> {"items"=> [{"description"=> [{"content"=>"shared.time-html", "data"=> {"date"=>"19 July 2018", "datetime-value"=>"2018-07-19"}}], "term"=>{"content"=>"laid-thing.laid-date"}}, {"description"=>[{"content"=>"groupName - 1"}], "term"=>{"content"=>"laid-thing.laying-body"}}, {"description"=>[{"content"=>"procedureName - 1"}],  "term"=>{"content"=>"laid-thing.procedure"}}]}, "name"=>"list__description"}}, "name"=>"card__generic"}]
      expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
    end
  end

  describe 'GET show' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.nt?proposed_negative_statutory_instrument_id=12345678",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.ttl?proposed_negative_statutory_instrument_id=12345678",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.tsv?proposed_negative_statutory_instrument_id=12345678",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.csv?proposed_negative_statutory_instrument_id=12345678",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.rj?proposed_negative_statutory_instrument_id=12345678",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.json?proposed_negative_statutory_instrument_id=12345678",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.xml?proposed_negative_statutory_instrument_id=12345678",
         :type => "application/rdf+xml" }]
    end

    before(:each) do
      allow(PageSerializer::ProposedNegativeStatutoryInstrumentsShowPageSerializer).to receive(:new)
      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :show, params: { proposed_negative_statutory_instrument_id: 12345678 }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @statutory_instrument' do
      expect(assigns(:proposed_negative_statutory_instrument)).to be_a(Grom::Node)
      expect(assigns(:proposed_negative_statutory_instrument).type).to include('https://id.parliament.uk/schema/ProposedNegativeStatutoryInstrumentPaper')
    end

    it 'calls the serializer correctly' do
      statutory_instrument = assigns(:proposed_negative_statutory_instrument)

      expect(PageSerializer::ProposedNegativeStatutoryInstrumentsShowPageSerializer).to have_received(:new).with(request: request, proposed_negative_statutory_instrument: statutory_instrument, data_alternates: data_alternates)
    end
  end

  describe 'GET lookup' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.nt?proposed_negative_statutory_instrument_id=12345678",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.ttl?proposed_negative_statutory_instrument_id=12345678",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.tsv?proposed_negative_statutory_instrument_id=12345678",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.csv?proposed_negative_statutory_instrument_id=12345678",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.rj?proposed_negative_statutory_instrument_id=12345678",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.json?proposed_negative_statutory_instrument_id=12345678",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/proposed_negative_statutory_instrument_by_id.xml?proposed_negative_statutory_instrument_id=12345678",
         :type => "application/rdf+xml" }]
    end

    before(:each) do
      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :lookup, params: { source: 'proposedNegativeStatutoryInstrumentPaperName', id: 'EU Export Credits Legislation (Revocation) (EU Exit) Regulations 2018'}
    end

    it 'should have a response with http status ok (302)' do
      expect(response).to have_http_status(302)
    end

    it 'assigns @proposed_negative_statutory_instrument' do
      expect(assigns(:proposed_negative_statutory_instrument)).to be_a(Grom::Node)
      expect(assigns(:proposed_negative_statutory_instrument).type).to include('https://id.parliament.uk/schema/ProposedNegativeStatutoryInstrumentPaper')
    end

    it 'redirects to proposed_negative_statutory_instruments/:id' do
      expect(response).to redirect_to('https://:/proposed-negative-statutory-instruments/dXG5AxDh')
    end
  end
end
