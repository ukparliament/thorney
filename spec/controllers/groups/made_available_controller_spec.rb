require 'rails_helper'

RSpec.describe Groups::MadeAvailableController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
        href: "#{ENV['PARLIAMENT_BASE_URL']}/group_layings_index.nt?group_id=XouN12Ow",
        type: 'application/n-triples'
      },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_layings_index.ttl?group_id=XouN12Ow",
         type: 'text/turtle' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_layings_index.tsv?group_id=XouN12Ow",
         type: 'text/tab-separated-values' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_layings_index.csv?group_id=XouN12Ow",
         type: 'text/csv' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_layings_index.rj?group_id=XouN12Ow",
         type: 'application/json+rdf' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_layings_index.json?group_id=XouN12Ow",
         type: 'application/json+ld' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_layings_index.xml?group_id=XouN12Ow",
         type: 'application/rdf+xml' }]
    end

    let(:heading) { 'a heading component' }

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new) { heading }

      allow(controller.request).to receive(:env).and_return({ 'ApplicationInsights.request.id' => '|1234abcd.' })

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
        expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading_content: 'Made Available', subheading_content: 'groupName - 1', subheading_link: '/groups/XouN12Ow')
      end

      it 'calls the ListPageSerializer correctly' do
        list_components = [{ 'data' =>
                                       { 'heading'          =>
                                                               { 'data' =>
                                                                           { 'content' =>
                                                                                          'laidThingName - 24',
                                                                             'link' =>
                                                                                 '/statutory-instruments/WBlaNvyq',
                                                                             'size'    => 2 },
                                                                 'name' => 'heading' },
                                         'list-description' =>
                                                               { 'data' =>
                                                                           { 'items' =>
                                                                                        [{ 'description' => [{ 'content' => '10 September 2018' }],
                                                                                           'term'        => { 'content' => 'laid-thing.laid-date' } }] },
                                                                 'name' => 'list__description' },
                                         'small'            =>
                                                               { 'data' => { 'content' => 'Statutory Instrument' },
                                                                 'name' => 'partials__small' } },
                             'name' => 'card__generic' },
                           { 'data' =>
                                       { 'heading'          =>
                                                               { 'data' =>
                                                                           { 'content' =>
                                                                                          'laidThingName - 23',
                                                                             'link' =>
                                                                                 '/statutory-instruments/BuMKAKjA',
                                                                             'size'    => 2 },
                                                                 'name' => 'heading' },
                                         'list-description' =>
                                                               { 'data' =>
                                                                           { 'items' =>
                                                                                        [{ 'description' => [{ 'content' => '6 September 2018' }],
                                                                                           +'term'       => { 'content' => 'laid-thing.laid-date' } }] },
                                                                 'name' => 'list__description' },
                                         'small'            =>
                                                               { 'data' => { 'content' => 'Statutory Instrument' },
                                                                 'name' => 'partials__small' } },
                             'name' => 'card__generic' },
                           { 'data' =>
                                       { 'heading'          =>
                                                               { 'data' =>
                                                                           { 'content' =>
                                                                                          'laidThingName - 21',
                                                                             'link' =>
                                                                                 '/proposed-negative-statutory-instruments/W3l3iqIJ',
                                                                             'size'    => 2 },
                                                                 'name' => 'heading' },
                                         'list-description' =>
                                                               { 'data' =>
                                                                           { 'items' =>
                                                                                        [{ 'description' => [{ 'content' => '25 July 2018' }],
                                                                                           'term'        => { 'content' => 'laid-thing.laid-date' } }] },
                                                                 'name' => 'list__description' },
                                         'small'            =>
                                                               { 'data' => { 'content' => 'Proposed Negative Statutory Instrument' },
                                                                 'name' => 'partials__small' } },
                             'name' => 'card__generic' },
                           { 'data' =>
                                       { 'heading'          =>
                                                               { 'data' =>
                                                                           { 'content' =>
                                                                                          'laidThingName - 1',
                                                                             'link' =>
                                                                                 '/statutory-instruments/QV9rpep6',
                                                                             'size'    => 2 },
                                                                 'name' => 'heading' },
                                         'list-description' =>
                                                               { 'data' =>
                                                                           { 'items' =>
                                                                                        [{ 'description' => [{ 'content' => '27 April 2018' }],
                                                                                           'term'        => { 'content' => 'laid-thing.laid-date' } }] },
                                                                 'name' => 'list__description' },
                                         'small'            =>
                                                               { 'data' => { 'content' => 'Statutory Instrument' },
                                                                 'name' => 'partials__small' } },
                             'name' => 'card__generic' }]

        expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
      end
    end
  end
end
