require 'rails_helper'

RSpec.describe ProcedureSteps::WorkPackagesController, vcr: true do
  describe 'GET index' do
    let(:data_alternates) do
      [{
           href: "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_work_packages.nt?procedure_step_id=e9G2vHbc",
           type: 'application/n-triples'
       },
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_work_packages.ttl?procedure_step_id=e9G2vHbc",
        type: 'text/turtle'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_work_packages.tsv?procedure_step_id=e9G2vHbc",
        type: 'text/tab-separated-values'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_work_packages.csv?procedure_step_id=e9G2vHbc",
        type: 'text/csv'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_work_packages.rj?procedure_step_id=e9G2vHbc",
        type: 'application/json+rdf'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_work_packages.json?procedure_step_id=e9G2vHbc",
        type: 'application/json+ld'},
       {href: "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_work_packages.xml?procedure_step_id=e9G2vHbc",
        type: 'application/rdf+xml'}]
    end

    let(:heading) {'a heading component'}

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new) {heading}

      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :index, params: {procedure_step_id: 'e9G2vHbc'}
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    context 'the correct instance variables' do
      it 'assigns @procedure_step' do
        expect(assigns(:procedure_step)).to be_a(Grom::Node)
        expect(assigns(:procedure_step).type).to include('https://id.parliament.uk/schema/ProcedureStep')
      end

      it 'assigns @business_items' do
        assigns(:business_items).each do |business_item|
          expect(business_item).to be_a(Grom::Node)
          expect(business_item.type).to include('https://id.parliament.uk/schema/BusinessItem')
        end
      end
    end

    context 'calling the serializers correctly' do
      it 'calls the Heading1ComponentSerializer correctly' do
        expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading: 'Work Packages', subheading: 'procedureStepName - 1', subheading_link: '/procedure-steps/e9G2vHbc')
      end

      it 'calls the ListPageSerializer correctly' do
        list_components = [{"data" =>
                                {"heading" =>
                                     {"data" =>
                                          {"content" => "workPackagedThingName - 4",
                                           "link" => "/work-packages/eCsYdAM3",
                                           "size" => 2},
                                      "name" => "heading"},
                                 "list-description" =>
                                     {"data" =>
                                          {"items" =>
                                               [{"description" => [{"content" => "16 May 2018"}],
                                                 "term" =>
                                                     {"content" =>
                                                          "procedure-steps.subsidiary-resources.actualised-date"}}]},
                                      "name" => "list__description"},
                                 "small" =>
                                     {"data" => {"content" => "laid-thing.work-package"},
                                      "name" => "partials__small"}},
                            "name" => "card__generic"},
                           {"data" =>
                                {"heading" =>
                                     {"data" =>
                                          {"content" => "workPackagedThingName - 2",
                                           "link" => "/work-packages/PsB0pq0l",
                                           "size" => 2},
                                      "name" => "heading"},
                                 "list-description" =>
                                     {"data" =>
                                          {"items" =>
                                               [{"description" => [{"content" => "9 May 2018"}],
                                                 "term" =>
                                                     {"content" =>
                                                          "procedure-steps.subsidiary-resources.actualised-date"}}]},
                                      "name" => "list__description"},
                                 "small" =>
                                     {"data" => {"content" => "laid-thing.work-package"},
                                      "name" => "partials__small"}},
                            "name" => "card__generic"},
                           {"data" =>
                                {"heading" =>
                                     {"data" =>
                                          {"content" => "workPackagedThingName - 3",
                                           "link" => "/work-packages/uBG5MdZZ",
                                           "size" => 2},
                                      "name" => "heading"},
                                 "list-description" =>
                                     {"data" =>
                                          {"items" =>
                                               [{"description" => [{"content" => "2 May 2018"}],
                                                 "term" =>
                                                     {"content" =>
                                                          "procedure-steps.subsidiary-resources.actualised-date"}}]},
                                      "name" => "list__description"},
                                 "small" =>
                                     {"data" => {"content" => "laid-thing.work-package"},
                                      "name" => "partials__small"}},
                            "name" => "card__generic"},
                           {"data" =>
                                {"heading" =>
                                     {"data" =>
                                          {"content" => "workPackagedThingName - 1",
                                           "link" => "/work-packages/UsdZhECl",
                                           "size" => 2},
                                      "name" => "heading"},
                                 "list-description" =>
                                     {"data" =>
                                          {"items" =>
                                               [{"description" => [{"content" => "2 May 2018"}],
                                                 "term" =>
                                                     {"content" =>
                                                          "procedure-steps.subsidiary-resources.actualised-date"}}]},
                                      "name" => "list__description"},
                                 "small" =>
                                     {"data" => {"content" => "laid-thing.work-package"},
                                      "name" => "partials__small"}},
                            "name" => "card__generic"}]

        expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
      end
    end
  end
end
