require 'rails_helper'

RSpec.describe Houses::MadeAvailable::AvailabilityTypes::LaidPapersController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
         href: "#{ENV['PARLIAMENT_BASE_URL']}/house_laid_papers.nt?house_id=WkUWUBMx",
         type: 'application/n-triples'
       },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/house_laid_papers.ttl?house_id=WkUWUBMx",
         type: 'text/turtle' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/house_laid_papers.tsv?house_id=WkUWUBMx",
         type: 'text/tab-separated-values' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/house_laid_papers.csv?house_id=WkUWUBMx",
         type: 'text/csv' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/house_laid_papers.rj?house_id=WkUWUBMx",
         type: 'application/json+rdf' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/house_laid_papers.json?house_id=WkUWUBMx",
         type: 'application/json+ld' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/house_laid_papers.xml?house_id=WkUWUBMx",
         type: 'application/rdf+xml' }]
    end

    let(:heading) { 'a heading component' }

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new) { heading }

      allow(controller.request).to receive(:env).and_return({ 'ApplicationInsights.request.id' => '|1234abcd.' })

      get :index, params: { house_id: 'WkUWUBMx' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    context 'the correct instance variables' do
      it 'assigns @house' do
        expect(assigns(:house)).to be_a(Grom::Node)
        expect(assigns(:house).type).to include('https://id.parliament.uk/schema/House')
      end

      it 'assigns @laid_papers' do
        assigns(:laid_papers).each do |laid_paper|
          expect(laid_paper).to be_a(Grom::Node)
          expect(laid_paper.type).to include('https://id.parliament.uk/schema/LaidThing')
        end
      end
    end

    context 'calling the serializers correctly' do
      it 'calls the Heading1ComponentSerializer correctly' do
        expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading: 'houseName - 1 - laid papers', subheading: 'houseName - 1', subheading_link: '/houses/WkUWUBMx')
      end

      it 'calls the ListPageSerializer correctly' do
        list_components = [{ 'data' =>
                               { 'heading'          =>
                                   { 'data' =>
                                       { 'content' =>
                                           "<a href=\"/statutory-instruments/HJ7BlYte\">laidThingName - 1</a>",
                                         'size'    => 2 },
                                     'name' => 'heading' },
                                 'list-description' =>
                                   { 'data' =>
                                       { 'items' =>
                                           [{ 'description' => [{ 'content' => 'shared.time-html',
                                                                  'data' => {"date"=>"8 May 2018", "datetime-value"=>"2018-05-08"}}],
                                              'term'        => { 'content' => 'laid-thing.laid-date' } },
                                            {"description"=>[{"content"=>"groupName - 1"}],
                                             "term"=>{"content"=>"laid-thing.laying-body"}},
                                            {"description"=>[{"content"=>"procedureName - 1"}],
                                             "term"=>{"content"=>"laid-thing.procedure"}}]},
                                     'name' => 'list__description' },
                                 'small'            =>
                                   { 'data' => { 'content' => 'Statutory instrument' },
                                     'name' => 'partials__small' } },
                             'name' => 'card__generic' },
                           { 'data' =>
                               { 'heading'          =>
                                   { 'data' =>
                                       { 'content' =>
                                           "<a href=\"/statutory-instruments/xic2yu5i\">laidThingName - 2</a>",
                                         'size'    => 2 },
                                     'name' => 'heading' },
                                 'list-description' =>
                                   { 'data' =>
                                       { 'items' =>
                                           [{ 'description' => [{ 'content' => 'shared.time-html',
                                                                  'data' => {"date"=>"20 April 2018", "datetime-value"=>"2018-04-20"}}],
                                              'term'        => { 'content' => 'laid-thing.laid-date' } },
                                            {"description"=>[{"content"=>"groupName - 2"}],
                                             "term"=>{"content"=>"laid-thing.laying-body"}},
                                            {"description"=>[{"content"=>"procedureName - 1"}],
                                             "term"=>{"content"=>"laid-thing.procedure"}}]},
                                     'name' => 'list__description' },
                                 'small'            =>
                                   { 'data' => { 'content' => 'Statutory instrument' },
                                     'name' => 'partials__small' } },
                             'name' => 'card__generic' }

        ]

        expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
      end
    end
  end
end
