require 'rails_helper'

RSpec.describe LaidPapersController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
        href: "#{ENV['PARLIAMENT_BASE_URL']}/laid_paper_index.nt",
        type: 'application/n-triples'
      },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/laid_paper_index.ttl",
         type: 'text/turtle' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/laid_paper_index.tsv",
         type: 'text/tab-separated-values' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/laid_paper_index.csv",
         type: 'text/csv' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/laid_paper_index.rj",
         type: 'application/json+rdf' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/laid_paper_index.json",
         type: 'application/json+ld' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/laid_paper_index.xml",
         type: 'application/rdf+xml' }]
    end

    let(:heading) { 'a heading component' }

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new) { heading }

      allow(controller.request).to receive(:env).and_return({ 'ApplicationInsights.request.id' => '|1234abcd.' })

      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    context 'the correct instance variables' do
      it 'assigns @laid_papers' do
        assigns(:laid_papers).each do |laid_paper|
          expect(laid_paper).to be_a(Grom::Node)
          expect(laid_paper.type).to include('https://id.parliament.uk/schema/LaidThing')
        end
      end
    end

    context 'calling the serializers correctly' do
      it 'calls the Heading1ComponentSerializer correctly' do
        expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with({ heading: 'Laid papers' })
      end

      it 'calls the ListPageSerializer correctly' do
        list_components = [{ 'data' =>
                                       { 'heading'          =>
                                                               { 'data' =>
                                                                           { 'content' =>
                                                                                          '<a href="/statutory-instruments/5trFJNih">laidThingName - 1</a>',
                                                                             'size'    => 2 },
                                                                 'name' => 'heading' },
                                         'list-description' =>
                                                               { 'data' =>
                                                                           { 'items' =>
                                                                                        [{ 'description' => [{ 'content' => 'shared.time-html', 'data' => { 'date' => '23 April 2018', 'datetime-value' => '2018-04-23' } }],
                                                                                           'term'        => { 'content' => 'laid-thing.laid-date' } },
                                                                                         { 'description' => [{ 'content'=>'groupName - 1' }],
                                                                                           'term'        => { 'content'=>'laid-thing.laying-body' } },
                                                                                         { 'description' => [{ 'content'=>'procedureName - 1' }],
                                                                                           'term'        => { 'content'=>'laid-thing.procedure' } }] },
                                                                 'name' => 'list__description' },
                                         'small'            =>
                                                               { 'data' => { 'content' => 'statutory-instruments.type' },
                                                                 'name' => 'partials__small' } },
                             'name' => 'card__generic' }]

        expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
      end
    end
  end
  describe 'GET show' do
    let(:data_alternates) do
      [{
        href: "#{ENV['PARLIAMENT_BASE_URL']}/laid_paper_by_id.nt?laid_paper_id=1234567",
        type: 'application/n-triples'
      },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/laid_paper_by_id.ttl?laid_paper_id=1234567",
         type: 'text/turtle' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/laid_paper_by_id.tsv?laid_paper_id=1234567",
         type: 'text/tab-separated-values' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/laid_paper_by_id.csv?laid_paper_id=1234567",
         type: 'text/csv' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/laid_paper_by_id.rj?laid_paper_id=1234567",
         type: 'application/json+rdf' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/laid_paper_by_id.json?laid_paper_id=1234567",
         type: 'application/json+ld' },
       { href: "#{ENV['PARLIAMENT_BASE_URL']}/laid_paper_by_id.xml?laid_paper_id=1234567",
         type: 'application/rdf+xml' }]
    end

    before(:each) do
      allow(PageSerializer::LayingsShowPageSerializer).to receive(:new)
      allow(controller.request).to receive(:env).and_return({ 'ApplicationInsights.request.id' => '|1234abcd.' })

      get :show, params: { laid_paper_id: 1_234_567 }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @procedure_step' do
      expect(assigns(:laying)).to be_a(Grom::Node)
      expect(assigns(:laying).type).to include('https://id.parliament.uk/schema/Laying')
    end

    it 'calls the serializer correctly' do
      laying = assigns(:laying)

      expect(PageSerializer::LayingsShowPageSerializer).to have_received(:new).with(request: request, laying: laying, data_alternates: data_alternates)
    end
  end
end
