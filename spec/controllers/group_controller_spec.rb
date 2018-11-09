require 'rails_helper'

RSpec.describe GroupsController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_index.nt",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_index.ttl",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_index.tsv",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_index.csv",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_index.rj",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_index.json",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_index.xml",
         :type => "application/rdf+xml" }]
    end

    let(:heading) { 'a heading component' }

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new).with(heading: 'Groups') { heading }

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
      list_components = [{"data"=> {"heading"=> {"data"=> {"content"=>"<a href="/laying-bodies">Laying bodies</a>", "size"=>2}, "name"=>"heading"}}, "name"=>"card__generic"}]

      expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
    end
  end

  describe 'GET show' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.nt?group_id=12345678",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.ttl?group_id=12345678",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.tsv?group_id=12345678",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.csv?group_id=12345678",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.rj?group_id=12345678",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.json?group_id=12345678",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_by_id.xml?group_id=12345678",
         :type => "application/rdf+xml" }]
    end

    before(:each) do
      allow(PageSerializer::GroupsShowPageSerializer).to receive(:new)

      get :show, params: { group_id: 12345678 }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @group' do
      expect(assigns(:group)).to be_a(Grom::Node)
      expect(assigns(:group).type).to include('https://id.parliament.uk/schema/Group')
    end

    it 'calls the serializer correctly' do
      group = assigns(:group)

      expect(PageSerializer::GroupsShowPageSerializer).to have_received(:new).with(request: request, group: group, data_alternates: data_alternates)
    end
  end
end
