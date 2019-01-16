require_relative '../rails_helper'

RSpec.describe ProcedureStepListComponentsFactory, type: :serializer, vcr: true do
  let(:response) { Parliament::Request::UrlRequest.new(base_url:   ENV['PARLIAMENT_BASE_URL'],
                                                       builder:    Parliament::Builder::NTripleResponseBuilder,
                                                       decorators: Parliament::Grom::Decorator).procedure_step_index.get }

  let(:procedure_steps) { response.filter('https://id.parliament.uk/schema/ProcedureStep') }

    it 'creates cards with the correct procedure steps data' do
      allow(ComponentSerializer::CardComponentSerializer).to receive(:new)

      described_class.build_components(procedure_steps: procedure_steps)

      expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(name: 'card__generic', data: { heading: { "data" => { "content" => "<a href=\"/procedure-steps/e9G2vHbc\">procedureStepName - 1</a>", "size" => 2 }, "name" => "heading" }, list_description: {"data"=> {"items"=> {"description"=>[{"content"=>"houseName - 1 and houseName - 2"}], "term"=>{"content"=>"procedure-steps.houses"}}}, "name"=>"list__description"}})

      expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(name: 'card__generic', data: { heading: { "data" => { "content" => "<a href=\"/procedure-steps/9ouoghbQ\">procedureStepName - 2</a>", "size" => 2 }, "name" => "heading" }})

      expect(ComponentSerializer::CardComponentSerializer).to have_received(:new).with(name: 'card__generic', data: { heading: { "data" => { "content" => "<a href=\"/procedure-steps/xAb8mi2D\">procedureStepName - 3</a>", "size" => 2 }, "name" => "heading" }, list_description: {"data"=> {"items"=> {"description"=>[{"content"=>"houseName - 2"}], "term"=>{"content"=>"procedure-steps.houses"}}}, "name"=>"list__description"}})
    end
end
