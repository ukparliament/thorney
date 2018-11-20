require 'rails_helper'

RSpec.describe Groups::MadeAvailable::AvailabilityTypes::LaidPapersController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
        href: "#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_index.nt?group_id=XouN12Ow",
        type: 'application/n-triples'
      },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_index.ttl?group_id=XouN12Ow",
         type: 'text/turtle' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_index.tsv?group_id=XouN12Ow",
         type: 'text/tab-separated-values' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_index.csv?group_id=XouN12Ow",
         type: 'text/csv' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_index.rj?group_id=XouN12Ow",
         type: 'application/json+rdf' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_index.json?group_id=XouN12Ow",
         type: 'application/json+ld' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/group_laid_papers_index.xml?group_id=XouN12Ow",
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

      it 'assigns @laid_papers' do
        assigns(:laid_papers).each do |laid_paper|
          expect(laid_paper).to be_a(Grom::Node)
          expect(laid_paper.type).to include('https://id.parliament.uk/schema/LaidThing')
        end
      end
    end

    context 'calling the serializers correctly' do
      it 'calls the Heading1ComponentSerializer correctly' do
        expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading: 'groupName - 1 - laid papers', subheading: 'groupName - 1', subheading_link: '/groups/XouN12Ow')
      end

      it 'calls the ListPageSerializer correctly' do
        list_components = [{ 'data' =>
                                       { 'heading'          =>
                                                               { 'data' =>
                                                                           { 'content' =>
                                                                                          "<a href=\"/statutory-instruments/keUmDe6y\">laidThingName - 1</a>",
                                                                             'size'    => 2 },
                                                                 'name' => 'heading' },
                                         'list-description' =>
                                                               { 'data' =>
                                                                           { 'items' =>
                                                                                        [{ 'description' => [{"content"=>"shared.time-html", "data"=>{"date"=>"27 April 2018", "datetime-value"=>"2018-04-27"}}],
                                                                                           'term'        => { 'content' => 'laid-thing.laid-date' } },
                                                                                           {"description"=>[{"content"=>"procedureName - 1"}],
                                                                                           "term"=>{"content"=>"laid-thing.procedure"}}
                                                                                           ] },
                                                                 'name' => 'list__description' },
                                         'small'            =>
                                                               { 'data' => { 'content' => 'Statutory instrument' },
                                                                 'name' => 'partials__small' } },
                             'name' => 'card__generic' }]

        expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
      end
    end
  end
end
