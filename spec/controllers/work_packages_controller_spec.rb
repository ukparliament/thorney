# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe WorkPackagesController, vcr: true do
  describe 'GET current' do
    let(:data_alternates) do
      [{
         :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_package_current.nt",
         :type => "application/n-triples" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_package_current.ttl",
         :type => "text/turtle" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_package_current.tsv",
         :type => "text/tab-separated-values" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_package_current.csv",
         :type => "text/csv" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_package_current.rj",
         :type => "application/json+rdf" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_package_current.json",
         :type => "application/json+ld" },
       { :href => "#{ENV['PARLIAMENT_BASE_URL']}/work_package_current.xml",
         :type => "application/rdf+xml" }]
    end

    let(:heading) { 'a heading component' }

    before(:each) do
      allow(PageSerializer::ListPageSerializer).to receive(:new)
      allow(ComponentSerializer::Heading1ComponentSerializer).to receive(:new).with(heading: 'Current Work Packages') { heading }

      allow(controller.request).to receive(:env).and_return({'ApplicationInsights.request.id' => '|1234abcd.'})

      get :current
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

    it 'calls the serializer correctly' do
      list_components = [{"data"=>
                            {"heading"=>
                               {"data"=>
                                  {"content"=>"workPackagedThingName - 1",
                                   "link"=>"/work-packages/rlJaCEwJ",
                                   "size"=>2},
                                "name"=>"heading"},
                             "list-description"=>
                               {"data"=>{"items"=>[{"description"=>[{"content"=>"shared.time-html", "data"=>{"date"=>"23 April 2018", "datetime-value"=>"2018-04-23"}}], "term"=>{"content"=>"laid-thing.laid-date"}}]}, "name"=>"list__description"}}, "name"=>"card__generic"}]

      expect(PageSerializer::ListPageSerializer).to have_received(:new).with(request: request, heading_component: heading, list_components: list_components, data_alternates: data_alternates)
    end
  end
end
