# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe Groups::LayingsController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
           :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_layings_index.nt?group_id=XouN12Ow",
           :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_layings_index.ttl?group_id=XouN12Ow",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_layings_index.tsv?group_id=XouN12Ow",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_layings_index.csv?group_id=XouN12Ow",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_layings_index.rj?group_id=XouN12Ow",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_layings_index.json?group_id=XouN12Ow",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/group_layings_index.xml?group_id=XouN12Ow",
         :type => "application/rdf+xml" }]
    end

    let(:heading) { 'a heading component' }

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new) { heading }

      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :index, params: { group_id: 'XouN12Ow' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    context 'the correct instance variables' do
      it 'assigns @group' do
        expect(assigns(:group)).to be_a(Grom::Node)
        expect(assigns(:group).type).to include('https://id.parliament.uk/schema/Group')
      end

      it 'assigns @layings' do
        assigns(:layings).each do |laying|
          expect(laying).to be_a(Grom::Node)
          expect(laying.type).to include('https://id.parliament.uk/schema/Laying')
        end
      end
    end

    context 'calling the serializers correctly' do
      it 'calls the Heading1ComponentSerializer correctly' do
        expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading_content: 'Layings', subheading_content: 'groupName - 1', subheading_link: '/groups/XouN12Ow')
      end

      it 'calls the ListPageSerializer correctly' do
        list_components = [{"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 1", "size"=>2, "link"=>"/statutory-instruments/QV9rpep6"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"27 April 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 2", "size"=>2, "link"=>"/statutory-instruments/HJ7BlYte"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"8 May 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 3", "size"=>2, "link"=>"/statutory-instruments/3dAYwLoB"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"3 April 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 4", "size"=>2, "link"=>"/statutory-instruments/rjzMGG28"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"21 May 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 5", "size"=>2, "link"=>"/statutory-instruments/uNiGNHey"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"24 May 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 6", "size"=>2, "link"=>"/statutory-instruments/8HUWJm9e"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"18 May 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 7", "size"=>2, "link"=>"/statutory-instruments/ez3sdNNT"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"4 June 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 8", "size"=>2, "link"=>"/statutory-instruments/w3m931qg"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"6 June 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 9", "size"=>2, "link"=>"/statutory-instruments/PhwmELqG"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"8 June 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 10", "size"=>2, "link"=>"/statutory-instruments/aQaZuLyK"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"13 June 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 11", "size"=>2, "link"=>"/statutory-instruments/I9rWxORS"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"13 June 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 12", "size"=>2, "link"=>"/statutory-instruments/9Nv0gELe"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"15 June 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 13", "size"=>2, "link"=>"/statutory-instruments/YhMNMpYo"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"18 June 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 14", "size"=>2, "link"=>"/statutory-instruments/UD4HjKbu"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"25 June 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 15", "size"=>2, "link"=>"/statutory-instruments/P5Zu6fkP"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"28 June 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 16", "size"=>2, "link"=>"/statutory-instruments/JXxhQblu"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"3 July 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 17", "size"=>2, "link"=>"/statutory-instruments/IjLgnN8z"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"2 July 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 18", "size"=>2, "link"=>"/statutory-instruments/BRZBy463"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"12 July 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 19", "size"=>2, "link"=>"/statutory-instruments/Uhsvsfdn"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"19 July 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 20", "size"=>2, "link"=>"/statutory-instruments/SbxmGLcR"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"20 July 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 21", "size"=>2, "link"=>"/proposed-negative-statutory-instruments/W3l3iqIJ"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"25 July 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Proposed Negative Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 22", "size"=>2, "link"=>"/statutory-instruments/hLF7ZU6f"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"26 July 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 23", "size"=>2, "link"=>"/statutory-instruments/BuMKAKjA"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"6 September 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 24", "size"=>2, "link"=>"/statutory-instruments/WBlaNvyq"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"10 September 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 25", "size"=>2, "link"=>"/statutory-instruments/lSRBYtGi"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"13 September 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}, {"name"=>"card__generic", "data"=>{"heading"=>{"name"=>"heading", "data"=>{"content"=>"laidThingName - 26", "size"=>2, "link"=>"/statutory-instruments/H1uGO0VI"}}, "paragraph"=>{"name"=>"paragraph", "data"=>[{"content"=>"groups.layings.date", "data"=>{"date"=>"13 September 2018"}}, {"content"=>"groups.layings.type", "data"=>{"type"=>"Statutory Instrument"}}]}}}]

        expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
      end
    end
  end
end
