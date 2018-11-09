require 'rails_helper'

RSpec.describe LayingBodiesController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/laying_body_index.nt",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/laying_body_index.ttl",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/laying_body_index.tsv",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/laying_body_index.csv",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/laying_body_index.rj",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/laying_body_index.json",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/laying_body_index.xml",
         :type => "application/rdf+xml" }]
    end

    let(:heading) { 'a heading component' }

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new).with(heading: 'Laying bodies') { heading }

      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @groups' do
      assigns(:groups).each do |group|
        expect(group).to be_a(Grom::Node)
        expect(group.type).to include('https://id.parliament.uk/schema/Group')
      end
    end

    it 'calls the serializer correctly' do
      list_components = [{"data"=> {"heading"=> {"data"=> {"content"=>"<a href=\"/groups/NDZSYjeE\">groupName - 1</a>", "size"=>2}, "name"=>"heading"}}, "name"=>"card__generic"}]

      expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
    end
  end
end
