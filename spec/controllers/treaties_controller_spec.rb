require 'rails_helper'

RSpec.describe TreatiesController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_index.nt",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_index.ttl",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_index.tsv",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_index.csv",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_index.rj",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_index.json",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_index.xml",
         :type => "application/rdf+xml" }]
    end

    let(:heading) { 'a heading component' }

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new).with(heading: 'Treaties') { heading }

      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @treaties' do
      assigns(:treaties).each do |treaty|
        expect(treaty).to be_a(Grom::Node)
        expect(treaty.type).to include('https://id.parliament.uk/schema/Treaty')
      end
    end

    it 'calls the serializer correctly' do
      list_components = [{"data"=> {"heading"=> {"data"=> {"content"=>"<a href=\"/treaties/gzoa2qc8\">laidThingName - 1</a>", "size"=>2}, "name"=>"heading"}, "list-description"=> {"data"=> {"items"=> [{"description"=>[{"content"=>"procedureName - 1"}],  "term"=>{"content"=>"laid-thing.procedure"}}]}, "name"=>"list__description"}}, "name"=>"card__generic"}]
      expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
    end
  end

  describe 'GET show' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_by_id.nt?treaty_id=gzoa2qc8",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_by_id.ttl?treaty_id=gzoa2qc8",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_by_id.tsv?treaty_id=gzoa2qc8",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_by_id.csv?treaty_id=gzoa2qc8",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_by_id.rj?treaty_id=gzoa2qc8",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_by_id.json?treaty_id=gzoa2qc8",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_by_id.xml?treaty_id=gzoa2qc8",
         :type => "application/rdf+xml" }]
    end

    before(:each) do
      allow(PageSerializer::TreatiesShowPageSerializer).to receive(:new)
      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :show, params: { treaty_id: 'gzoa2qc8' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @treaty' do
      expect(assigns(:treaty)).to be_a(Grom::Node)
      expect(assigns(:treaty).type).to include('https://id.parliament.uk/schema/Treaty')
    end

    it 'calls the serializer correctly' do
      treaty = assigns(:treaty)

      expect(PageSerializer::TreatiesShowPageSerializer).to have_received(:new).with(request: request, treaty: treaty, data_alternates: data_alternates)
    end
  end

  describe 'GET lookup' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_by_id.nt?treaty_id=gzoa2qc8",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_by_id.ttl?treaty_id=gzoa2qc8",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_by_id.tsv?treaty_id=gzoa2qc8",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_by_id.csv?treaty_id=gzoa2qc8",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_by_id.rj?treaty_id=gzoa2qc8",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_by_id.json?treaty_id=gzoa2qc8",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/treaty_by_id.xml?treaty_id=gzoa2qc8",
         :type => "application/rdf+xml" }]
    end

    before(:each) do
      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :lookup, params: { treaty_id: 'gzoa2qc8', source: 'treatyName', id: 'Treaty test 1'}
    end

    it 'should have a response with http status ok (302)' do
      expect(response).to have_http_status(302)
    end

    it 'assigns @treaty' do
      expect(assigns(:treaty)).to be_a(Grom::Node)
      expect(assigns(:treaty).type).to include('https://id.parliament.uk/schema/Treaty')
    end

    it 'redirects to treaties/:id' do
      expect(response).to redirect_to('https://:/treaties/gzoa2qc8')
    end
  end
end
