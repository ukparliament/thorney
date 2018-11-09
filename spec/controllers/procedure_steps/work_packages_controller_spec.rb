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

      it 'assigns @work_packages' do
        assigns(:work_packages).each do |work_package|
          expect(work_package).to be_a(Grom::Node)
          expect(work_package.type).to include('https://id.parliament.uk/schema/WorkPackage')
        end
      end
    end

    context 'calling the serializers correctly' do
      it 'calls the Heading1ComponentSerializer correctly' do
        expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading: 'procedureStepName - 1 - procedural activity', subheading: 'procedureStepName - 1', subheading_link: '/procedure-steps/e9G2vHbc')
      end

      it 'calls the ListPageSerializer correctly' do
        list_components = [{"data" =>
                                {"heading" =>
                                     {"data" =>
                                          {"content" => "<a href=\"/work-packages/UsdZhECl\">workPackagedThingName - 1</a>",
                                           "size" => 2},
                                      "name" => "heading"},
                                 "list-description" =>
                                     {"data" =>
                                          {"items" =>
                                               [{"description"=>[{"content"=>"procedureName - 1"}],
                                                 "term"=>{"content"=>"laid-thing.procedure"}},
                                                 {"description" => [{"content" => "shared.time-html",
                                                                    "data"=>{"date"=>"2 May 2018", "datetime-value"=>"2018-05-02"}}],
                                                 "term" =>
                                                     {"content" =>
                                                          "procedure-steps.subsidiary-resources.actualised-date"}}]},
                                      "name" => "list__description"}},
                            "name" => "card__generic"}]

        expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
      end
    end
  end

  describe 'GET current' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_work_packages_current.nt?procedure_step_id=e9G2vHbc",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_work_packages_current.ttl?procedure_step_id=e9G2vHbc",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_work_packages_current.tsv?procedure_step_id=e9G2vHbc",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_work_packages_current.csv?procedure_step_id=e9G2vHbc",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_work_packages_current.rj?procedure_step_id=e9G2vHbc",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_work_packages_current.json?procedure_step_id=e9G2vHbc",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/procedure_step_work_packages_current.xml?procedure_step_id=e9G2vHbc",
         :type => "application/rdf+xml" }]
    end

    let(:heading) { 'a heading component' }

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new) { heading }

      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :current, params: {procedure_step_id: 'e9G2vHbc'}
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @work_packages' do
      assigns(:work_packages).each do |work_package|
        expect(work_package).to be_a(Grom::Node)
        expect(work_package.type).to include('https://id.parliament.uk/schema/WorkPackage')
      end
    end

    context 'calling the serializer correctly' do
      it 'calls the Heading1ComponentSerializer correctly' do
        expect(ComponentSerializer::Heading1ComponentSerializer).to have_received(:new).with(heading: 'procedureStepName - 1 - current procedural activity', subheading: 'procedureStepName - 1', subheading_link: '/procedure-steps/e9G2vHbc')
      end

      it 'calls the ListPageSerializer correctly' do
        list_components = [{"data"=>
                              {"heading"=>
                                 {"data"=>
                                    {"content"=>"workPackagedThingName - 1",
                                     "link"=>"/work-packages/PsB0pq0l",
                                     "size"=>2},
                                  "name"=>"heading"},
                               "list-description"=>
                                 {"data"=>{"items"=>[{"description"=>[{"content"=>"procedureName - 1"}],
                                                      "term"=>{"content"=>"laid-thing.procedure"}}, {"description"=>[{"content"=>"shared.time-html", "data"=>{"date"=>"9 May 2018", "datetime-value"=>"2018-05-09"}}], "term"=>{"content"=>"procedure-steps.subsidiary-resources.actualised-date"}}]}, "name"=>"list__description"}}, "name"=>"card__generic"}]

        expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
      end
    end
  end
end
